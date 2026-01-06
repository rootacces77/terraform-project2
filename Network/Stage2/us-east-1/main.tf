module "tgw" {
    source = "./TGW"

    tgw_peering_id_eu_central_1 = var.tgw_peering_id_eu_central_1
    tgw_peering_id_us_west_1    = var.tgw_peering_id_us_west_1
    tgw_rt_id                   = var.tgw_rt_id
    vpc_eu_central_1_cidr       = var.vpc_eu_central_1_cidr
    vpc_us_west_1_cidr          = var.vpc_us_west_1_cidr
  
}

module "routes" {
    source = "./ROUTES"

    vpc_1_vpn_rt_id       = var.vpc_1_vpn_rt_id
    vpc_eu_central_1_cidr = var.vpc_eu_central_1_cidr
    vpc_us_west_1_cidr    = var.vpc_us_west_1_cidr
    tgw_id                = var.tgw_id

  
}


module "NetworkManager" {
    source = "./NetworkManager"
    
    tgw_arn_eu_central_1 = var.tgw_arn_eu_central_1
    tgw_arn_us_east_1 = var.tgw_arn_us_east_1
    tgw_arn_us_west_1 = var.tgw_arn_us_west_1

} 