output "tgw_peering_id_eu_central_1" {
    value = module.eu_central_1.tgw_peering_id
    description = "TGW Peering ID between eu_central_1 and us_east_1"
  
}

output "tgw_peering_id_us_west_1" {
    value = module.us_west_1.tgw_peering_id
    description = "TGW Peering ID between us_west_1 and us_east_1"
  
}

output "tgw_rt_id_eu_central_1" {
    value = module.eu_central_1.tgw_rt_id
    description = "TGW Main RT ID"
  
}

output "tgw_rt_id_us_west_1" {
    value = module.us_west_1.tgw_rt_id
    description = "TGW Main RT ID"
  
}

output "vpc1_vpn_rt_id_us_east_1" {
  value = module.us_east_1.vpc1_vpn_rt_id
  description = "ID of VPC_1 VPN Subnet RT "
  
}

output "vpc_cidr_eu_central_1" {
  value = module.eu_central_1.vpc_cidr
  description = "CIDR of VPC 1"
}

output "vpc_cidr_us_west_1" {
  value = module.us_west_1.vpc_cidr
  description = "CIDR of VPC 1"
}

output "tgw_arn_us_east_1" {
    value = module.us_east_1.tgw_arn
  
}

output "tgw_arn_us_west_1" {
    value = module.us_west_1.tgw_arn
  
}

output "tgw_arn_eu_central_1" {
    value = module.eu_central_1.tgw_arn
  
}

output "tgw_id_us_east_1" {
    value = module.us_east_1.tgw_id
  
}

output "tgw_rt_id_us_east_1" {
    value = module.us_east_1.tgw_rt_id
}