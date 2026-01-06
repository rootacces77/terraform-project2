module "us_east_1" {

    source = "./us_east_1"
    providers = {
      aws = aws.us_east_1
    }

    tgw_id                      = local.tgw_id_us_east_1
    tgw_rt_id                   = local.tgw_rt_id_us_east_1

    tgw_peering_id_eu_central_1 = local.tgw_peering_id_eu_central_1
    tgw_peering_id_us_west_1    = local.tgw_peering_id_us_west_1

    vpc_1_vpn_rt_id             = local.vpc1_vpn_rt_id_us_east_1
    vpc_eu_central_1_cidr       = local.vpc_cidr_eu_central_1
    vpc_us_west_1_cidr          = local.vpc_cidr_us_west_1

    tgw_arn_eu_central_1        = local.tgw_arn_eu_central_1
    tgw_arn_us_east_1           = local.tgw_arn_us_east_1
    tgw_arn_us_west_1           = local.tgw_arn_us_west_1
  
}

module "eu_central_1" {
    source  = "./eu_central_1"
    depends_on = [ module.us_east_1 ]
    providers = {
      aws = aws.eu_central_1
    }


    tgw_peering_attachment_id = local.tgw_peering_id_eu_central_1
    tgw_route_table_id        = local.tgw_rt_id_eu_central_1
  
}

module "us_west_1" {
    source  = "./eu_central_1"
    depends_on = [ module.us_east_1 ]
    providers = {
      aws = aws.us_west_1
    }


    tgw_peering_attachment_id = local.tgw_peering_id_us_west_1
    tgw_route_table_id        = local.tgw_rt_id_us_west_1
  
}
