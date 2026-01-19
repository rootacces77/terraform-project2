resource "aws_acm_certificate" "clientvpn_server" {
  private_key       = file(local.server_key_path)
  certificate_body  = file(local.server_cert_path)
  certificate_chain = file(local.server_chain_path)

  tags = {
    Name = var.acm_certificate_name
  }

  lifecycle {
    create_before_destroy = false
  }
}


resource "aws_acm_certificate" "client_root_ca" {
  certificate_body = file(local.server_chain_path)
  private_key      = file(local.client_root_ca_key_path)

  tags = {
    Name = "vpn-client-root-ca"
  }
}