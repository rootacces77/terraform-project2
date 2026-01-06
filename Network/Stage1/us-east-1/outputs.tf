output "vpc_1_id" {
    value = module.vpc_1.vpc_id
    description = "VPC_1 ID"
}

output "vpc_2_id" {
    value = module.vpc_2.vpc_id
    description = "VPC_2 ID"
}

output "tgw_id" {
    value = module.tgw.tgw_id
    description = "TGW ID"
  
}

output "tgw_rt_id" {
    value = module.tgw.tgw_rt_id
  
}

output "vpc1_vpn_rt_id" {
  value = module.vpc_1.vpc1_vpn_rt_id
  description = "ID of VPC_1 VPN Subnet RT "
  
}

output "tgw_arn" {
    value = module.tgw.tgw_arn
  
}