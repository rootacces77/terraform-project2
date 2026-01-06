variable "tgw_peering_id_eu_central_1" {
    type = string
    description = "TGW peering ID EU CENTRAL 1"
}

variable "tgw_peering_id_us_west_1" {
    type = string
    description = "TGW peering ID US_WEST_1"
}

variable "tgw_rt_id" {
    type = string
    description = "TGW RT ID"
  
}

variable "tgw_id" {

    type = string
    description = "ID of TGW"
  
}

variable "vpc_1_vpn_rt_id" {
    type = string
    description = "us_east_1 VPC_1 VPN SUBNET RT ID"
  
}

variable "vpc_us_west_1_cidr" {
    type = string
    description = "us_west_1 VPC_1 CIDR"
  
}

variable "vpc_eu_central_1_cidr" {
    type = string
    description = "eu_central_1 VPC_1 CIDR"
  
}


variable "tgw_arn_eu_central_1" {
    type  = string
  
}

variable "tgw_arn_us_west_1" {
    type = string
  
}


variable "tgw_arn_us_east_1" {
    type = string
  
}