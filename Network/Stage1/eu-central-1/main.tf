module "vpc-1" {
  source = "./VPC-1"
}


module "tgw" {
    source = "./TGW"

    name = "eu-central-1"

    vpc-1-id = module.vpc-1.vpc_id

    vpc-1-subnet-ids = module.vpc-1.vpc_1_vpn_subnets_ids
}

module "ram" {
    source = "./RAM"

    prod_account_id   = var.prod_account_id
    vpc-1-subnet-arns = tolist(flatten([module.vpc-1.vpc_1_private1_subnets,module.vpc-1.vpc_1_private2_subnets,module.vpc-1.vpc_1_public_subnets]))
  
}