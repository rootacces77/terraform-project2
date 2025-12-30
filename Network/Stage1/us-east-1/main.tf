module "vpc-1" {
  source = "./VPC-1"
}

module "vpc-2" {
    source = "./VPC-2"
  
}

module "tgw" {
    source = "./TGW"

    name = "us-east-1"

    vpc-1-id = module.vpc-1.vpc_id
    vpc-2-id = module.vpc-2.vpc_id

    vpc-1-subnet-ids = module.vpc-1.vpc_1_vpn_subnets_ids
    vpc-2-subnet-ids = module.vpc-2.vpc_2_private1_subnets_ids
}

module "routes" {
    source = "./ROUTES"

    tgw-id = module.tgw.tgw-id

    vpc-1-vpn-rt-id = module.vpc-1.vpc1-vpn-rt-id
    vpc-2-cidr      = module.vpc-2.vpc_cidr
  
}