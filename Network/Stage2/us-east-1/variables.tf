variable "tgw-peering-id-eu-central-1" {
    type = string
    description = "TGW peering ID EU CENTRAL 1"
}

variable "tgw-peering-id-us-west-1" {
    type = string
    description = "TGW peering ID US-WEST-1"
}

variable "tgw-rt-id" {
    type = string
    description = "TGW RT ID"
  
}

variable "tgw-id" {

    type = string
    description = "ID of TGW"
  
}

variable "vpc-1-vpn-rt-id" {
    type = string
    description = "us-east-1 VPC-1 VPN SUBNET RT ID"
  
}

variable "vpc-us-west-1-cidr" {
    type = string
    description = "us-west-1 VPC-1 CIDR"
  
}

variable "vpc-eu-central-1-cidr" {
    type = string
    description = "eu-central-1 VPC-1 CIDR"
  
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