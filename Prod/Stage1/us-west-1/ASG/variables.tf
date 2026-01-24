variable "nlb_subnet_cidrs" {
    type = string(list)
    description = "List of NLB subnet CIDR's"
  
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "app_port" {
    type = number
    description = "Port of APP"
    default = 8080
  
}

variable "app_instance_type" {
    type        = string
    description = "Type of instance for APP EC2"
    default     = "t2.micro"
  
}

variable "app_asg_target_group_arn" {
    type = string
    description = "APP Target Group ARN"
  
}

variable "sec_asg_target_group_arn" {
    type = string
    description = "Security Target Group ARN"
  
}

variable "app_subnet_ids" {
    type = string(list)
    description = "APP Subnet IDS"
  
}

variable "sec_subnet_ids" {
    type = string(list)
    description = "Sec Subnet IDS"
  
}

variable "tg_port" {
  type = string
  description = "Target Group Port"
  default = "80"
}
