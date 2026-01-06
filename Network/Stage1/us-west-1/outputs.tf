output "tgw_id" {
  value = module.tgw.tgw_id
  description = "TGW ID"
}

output "vpc_1_id" {
    value = module.vpc_1.vpc_id
  
}

output "tgw_peering_id" {
    value = module.tgw.tgw_peering_id
    description = "TGW Peering ID between us_west_1 and us_east_1"
  
}

output "tgw_rt_id" {
    value = module.tgw.tgw_rt_id
    description = "TGW Main RT ID"
  
}

output "vpc_cidr" {
  value = module.vpc_1.vpc_cidr
  description = "CIDR of VPC 1"
}

output "tgw_arn" {
    value = module.tgw.tgw_arn
  
}

