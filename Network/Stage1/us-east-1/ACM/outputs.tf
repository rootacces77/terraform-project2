output "clientvpn_server_acm_arn" {
  value       = aws_acm_certificate.clientvpn_server.arn
  description = "ClientVPN Server Cert ARN"
}

output "vpn_certificate_chain" {
  value = aws_acm_certificate.client_root_ca.arn
  
}