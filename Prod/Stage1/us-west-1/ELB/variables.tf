
variable "tg_port" {
  type = string
  description = "Target Group Port"
  default = "80"
}

variable "target_type" {
  description = "Target type (instance, ip, lambda)"
  type        = string
  default     = "instance"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "nlb_subnet_ids" {
    type = list(string)
    description = "List of NLB subnet ids"
  
}

variable "nlb_app_port" {
    type = number
    description = "Port of APP"
    default = 8080
  
}

variable "nlb_app_protocol" {
    type = string
    description = "Protocol of APP port UDP/TCP"
    default = "UDP"
  
}