variable "tgw_name" {
    type = string
    description = "Name of the TGW"
  
}

variable "vpc_1_id" {
    type = string
    description = "ID of VPC_1"
  
}

variable "vpc_1_subnet_ids" {
    type = list(string)
    description = "ID's of VPC_1 subnets"
  
}

variable "us_east_1_tgw_id" {
    type = string
    description = "US_EAST_1 TGW ID"
  
}

variable "region_name" {
    type = string
    description = "TGW Peering attachment region id"
    default = "us_east_1"
  
}