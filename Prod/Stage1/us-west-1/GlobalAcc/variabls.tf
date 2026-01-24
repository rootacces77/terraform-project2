variable "listener_port" {
  type    = number
  default = 8080
}
variable "nlb_arn" {
  type        = string
  description = "ARN of the Network Load Balancer to target"
}