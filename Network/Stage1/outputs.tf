output "tgw-peering-id-eu-central-1" {
    value = module.eu-central-1.tgw-peering-id
    description = "TGW Peering ID between eu-central-1 and us-east-1"
  
}

output "tgw-peering-id-us-west-1" {
    value = module.us-west-1.tgw-peering-id
    description = "TGW Peering ID between us-west-1 and us-east-1"
  
}

output "tgw-rt-id-eu-central-1" {
    value = module.eu-central-1.tgw-rt-id
    description = "TGW Main RT ID"
  
}

output "tgw-rt-id-us-west-1" {
    value = module.us-west-1.tgw-rt-id
    description = "TGW Main RT ID"
  
}

output "vpc1-vpn-rt-id-us-east-1" {
  value = module.us-east-1.vpc1-vpn-rt-id
  description = "ID of VPC-1 VPN Subnet RT "
  
}

output "vpc-cidr-eu-central-1" {
  value = module.eu-central-1.vpc-cidr
  description = "CIDR of VPC 1"
}

output "vpc-cidr-us-west-1" {
  value = module.us-west-1.vpc-cidr
  description = "CIDR of VPC 1"
}

output "tgw-arn-us-east-1" {
    value = module.us-east-1.tgw-arn
  
}

output "tgw-arn-us-west-1" {
    value = module.us-west-1.tgw-arn
  
}

output "tgw-arn-eu-central-1" {
    value = module.eu-central-1.tgw-arn
  
}

output "tgw-id-us-east-1" {
    value = module.us-east-1.tgw-id
  
}

output "tgw-rt-id-us-east-1" {
    value = module.us-east-1.tgw-rt-id
}