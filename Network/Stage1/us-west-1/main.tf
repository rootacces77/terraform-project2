module "vpc_1" {
  source = "./VPC_1"
}


module "tgw" {
    source = "./TGW"

    tgw_name = "us_west_1"

    vpc_1_id = module.vpc_1.vpc_id
    vpc_1_subnet_ids = module.vpc_1.vpc_1_vpn_subnets_ids
    us_east_1_tgw_id = var.us_east_1_tgw_id

}

module "ram" {
    source = "./RAM"

    prod_account_id   = var.prod_account_id
    vpc_1_subnet_arns = tolist(flatten([module.vpc_1.vpc_1_private1_subnets,module.vpc_1.vpc_1_private2_subnets,module.vpc_1.vpc_1_public_subnets]))
  
}

module "routes" {
    source = "./ROUTES"

    vpc_1_private1_rt_id = module.vpc_1.vpc1_private1_rt_id
    tgw_id = module.tgw.tgw_id
    vpc_1_us_east_1_cidr = var.vpc_1_us_east_1_cidr
  
}

