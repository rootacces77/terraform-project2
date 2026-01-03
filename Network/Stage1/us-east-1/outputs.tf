output "vpc-1-id" {
    value = module.vpc-1.vpc_id
    description = "VPC-1 ID"
}

output "vpc-2-id" {
    value = module.vpc-2.vpc_id
    description = "VPC-2 ID"
}

output "tgw-id" {
    value = module.tgw.tgw-id
    description = "TGW ID"
  
}

output "vpc1-vpn-rt-id" {
  value = module.vpc-1.vpc1-vpn-rt-id
  description = "ID of VPC-1 VPN Subnet RT "
  
}

output "tgw-arn" {
    value = module.tgw.tgw-arn
  
}