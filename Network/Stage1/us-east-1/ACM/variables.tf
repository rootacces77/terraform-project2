
locals {
  server_cert_path  = "${path.module}/ClientVPNCerts/server.crt"
  server_key_path   = "${path.module}/ClientVPNCerts/server.key"
  server_chain_path         = "${path.module}/ClientVPNCerts/ca.crt"
  client_root_ca_key_path       = "${path.module}/ClientVPNCerts/ca.key"

}

/*
variable "server_cert_path" {
  description = "Path to server certificate PEM (e.g., ./certs/server.crt)"
  type        = string
  default = "${path.module}/ClientVPNCerts/server.crt"
}

variable "server_key_path" {
  description = "Path to server private key PEM (e.g., ./certs/server.key)"
  type        = string
  sensitive   = true
  default = "${path.module}/ClientVPNCerts/server.key"
}

variable "server_chain_path" {
  description = "Path to certificate chain PEM (e.g., ./certs/ca.crt). Can be empty if not needed."
  type        = string
  default     = "${path.module}/ClientVPNCerts/ca.crt"
}
*/

variable "acm_certificate_name" {
  description = "Tag Name for the imported ACM certificate"
  type        = string
  default     = "clientvpn-server-cert"
}