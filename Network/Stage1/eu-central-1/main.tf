module "vpc_1" {
  source = "./VPC-1"
}

module "tgw" {
    source = "./TGW"

    tgw_name = "eu_central_1"

    vpc_1_id = module.vpc_1.vpc_id
    us_east_1_tgw_id = var.us_east_1_tgw_id

    vpc_1_subnet_ids = module.vpc_1.vpc_1_private1_subnets_ids
}

module "ram" {
    source = "./RAM"

    prod_account_id   = var.prod_account_id
    vpc_1_subnet_arns = tolist(flatten([module.vpc_1.vpc_1_private1_subnets,module.vpc_1.vpc_1_private2_subnets,module.vpc_1.vpc_1_public_subnets]))
  
}