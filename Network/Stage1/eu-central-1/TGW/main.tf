############################################
# Transit Gateway
############################################
resource "aws_ec2_transit_gateway" "this" {
  description                     = "${var.name}-tgw"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "${var.name}-tgw"
  }
}

############################################
# TGW Route Tables
############################################
resource "aws_ec2_transit_gateway_route_table" "rt_main" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "${var.name}-tgw-rt-main"
  }
}



############################################
# VPC Attachments
############################################
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_1" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc-1-id
  subnet_ids         = var.vpc-1-subnet-ids

  dns_support  = "enable"
  ipv6_support = "disable"

  tags = {
    Name = "${var.name}-attach-vpc-1"
  }
}


############################################
# Associations (decide which TGW RT is used
# for traffic COMING FROM each VPC)
############################################
# VPC-A traffic uses rt_main (so A can route to B)
resource "aws_ec2_transit_gateway_route_table_association" "assoc_a" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_main.id
}



############################################
# TGW Attachments (eu-central-1 -> us-east-1)
############################################
resource "aws_ec2_transit_gateway_peering_attachment" "tgw-peering" {
  transit_gateway_id      = aws_ec2_transit_gateway.this.id
  peer_transit_gateway_id = var.us-east-1-tgw-id
  peer_region             = var.region-name


  tags = {
    Name = "${var.name}-attach-${var.region-name}-tgw"
  }
}
