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