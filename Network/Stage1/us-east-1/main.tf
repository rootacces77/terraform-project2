module "vpc_1" {
  source = "./VPC-1"
}

module "vpc_2" {
    source = "./VPC-2"
  
}

module "tgw" {
    source = "./TGW"

    tgw_name = "us_east_1"

    vpc_1_id = module.vpc_1.vpc_id
    vpc_2_id = module.vpc_2.vpc_id

    vpc_1_subnet_ids = module.vpc_1.vpc_1_vpn_subnets_ids
    vpc_2_subnet_ids = module.vpc_2.vpc_2_private1_subnets_ids
}

module "routes" {
    source = "./ROUTES"

    depends_on = [ module.tgw ]

    tgw_id = module.tgw.tgw_id

    vpc_1_vpn_rt_id = module.vpc_1.vpc1_vpn_rt_id
    vpc_2_cidr      = module.vpc_2.vpc_cidr
  
}


module "ram" {
    source = "./RAM"

    prod_account_id   = var.prod_account_id
    vpc_2_subnet_arns = tolist(flatten([module.vpc_2.vpc_2_private1_subnets,module.vpc_2.vpc_2_private2_subnets,module.vpc_2.vpc_2_public_subnets]))
  
}