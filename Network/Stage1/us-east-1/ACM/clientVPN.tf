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

