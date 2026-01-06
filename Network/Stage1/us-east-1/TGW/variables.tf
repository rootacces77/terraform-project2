variable "tgw_name" {
    type = string
    description = "Name of the TGW"
  
}

variable "vpc_1_id" {
    type = string
    description = "ID of VPC_1"
  
}

variable "vpc_2_id" {
    type = string
    description = "ID of VPC_2"
  
}

variable "vpc_1_subnet_ids" {
    type = list(string)
    description = "ID's of VPC_1 subnets"
  
}

variable "vpc_2_subnet_ids" {
    type = list(string)
    description = "ID's of VPC_2 subnets"
  
}