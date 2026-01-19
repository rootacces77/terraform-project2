variable "name" {
  type        = string
  description = "Name prefix for Client VPN resources"
  default     = "clientvpn"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where Client VPN will be associated"
}

variable "associated_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs (typically 2 AZs) to associate the Client VPN endpoint with"
}

variable "client_cidr_block" {
  type        = string
  description = "Client IPv4 CIDR block for Client VPN (must be /12 to /22 and non-overlapping)"
  default     = "172.16.0.0/22"
}

variable "vpc_target_cidr" {
  type        = string
  description = "Destination network clients should access (your VPC CIDR)"
  default     = "10.16.0.0/16"
}

variable "server_certificate_arn" {
  type        = string
  description = "ACM ARN for the server certificate (must be in same region)"
}

variable "client_root_certificate_chain_pem_path" {
  type        = string
  description = "Path to client root CA cert PEM (ca.crt) used for mutual auth"
}

variable "vpn_endpoint_security_group_id" {
  type        = string
  description = "Security group ID attached to the Client VPN endpoint association"
}

variable "log_retention_days" {
  type        = number
  default     = 14
}

variable "transport_protocol" {
  type        = string
  description = "UDP or TCP"
  default     = "udp"

}