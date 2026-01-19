resource "aws_cloudwatch_log_group" "clientvpn" {
  name              = "/aws/clientvpn/${var.name}"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_stream" "clientvpn" {
  name           = "${var.name}-connections"
  log_group_name = aws_cloudwatch_log_group.clientvpn.name
}

resource "aws_ec2_client_vpn_endpoint" "this" {
  description            = "${var.name}-endpoint"
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block

  split_tunnel     = true
  transport_protocol = var.transport_protocol

  vpc_id             = var.vpc_id
  security_group_ids = [var.vpn_endpoint_security_group_id]

  # Optional: If you set this, clients use these resolvers.
  # dns_servers = length(var.dns_servers) > 0 ? var.dns_servers : null

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.client_root_ca.arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.clientvpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.clientvpn.name
  }

  tags = {
    Name = "${var.name}-endpoint"
  }
}

# Import the client root CA into ACM so we can reference it by ARN in auth options.
# This is REQUIRED by aws_ec2_client_vpn_endpoint.authentication_options.root_certificate_chain_arn.
# Note: This is *not* your server cert; it's the CA cert used to validate client certs.
resource "aws_acm_certificate" "client_root_ca" {
  certificate_body = file(var.client_root_certificate_chain_pem_path)

  tags = {
    Name = "${var.name}-client-root-ca"
  }
}

# Associate endpoint with subnets (1+). Usually 2 for HA.
resource "aws_ec2_client_vpn_network_association" "assoc" {
  for_each               = toset(var.associated_subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = each.value
}

# Routes: allow clients to reach VPC CIDR via each associated subnet (keeps it simple + HA-friendly)
resource "aws_ec2_client_vpn_route" "to_vpc" {
  for_each               = aws_ec2_client_vpn_network_association.assoc
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id

  destination_cidr_block = var.vpc_target_cidr
  target_vpc_subnet_id   = each.value.subnet_id
  description            = "Route to VPC CIDR ${var.vpc_target_cidr}"
}

# Authorization: allow access to VPC CIDR (All groups). This is the usual starting point for mutual cert.
resource "aws_ec2_client_vpn_authorization_rule" "allow_vpc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = var.vpc_target_cidr

  authorize_all_groups = true
  description          = "Allow access to ${var.vpc_target_cidr}"
}