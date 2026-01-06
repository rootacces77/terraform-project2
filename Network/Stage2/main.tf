module "us-east-1" {

    source = "./us-east-1"
    providers = {
      aws = aws.us-east-1
    }

    tgw-id                      = local.tgw-id-us-east-1
    tgw-rt-id                   = local.tgw-rt-id-us-east-1

    tgw-peering-id-eu-central-1 = local.tgw-peering-id-eu-central-1
    tgw-peering-id-us-west-1    = local.tgw-peering-id-us-west-1

    vpc-1-vpn-rt-id             = local.vpc1-vpn-rt-id-us-east-1
    vpc-eu-central-1-cidr       = local.vpc-cidr-eu-central-1
    vpc-us-west-1-cidr          = local.vpc-cidr-us-west-1

    tgw_arn_eu_central_1        = local.tgw-arn-eu-central-1
    tgw_arn_us_east_1           = local.tgw-arn-us-east-1
    tgw_arn_us_west_1           = local.tgw-arn-us-west-1
  
}

module "eu-central-1" {
    source  = "./eu-central-1"
    depends_on = [ module.us-east-1 ]
    providers = {
      aws = aws.eu-central-1
    }


    tgw-peering_attachment_id = local.tgw-peering-id-eu-central-1
    tgw-route_table_id        = local.tgw-rt-id-eu-central-1
  
}

module "us-west-1" {
    source  = "./eu-central-1"
    depends_on = [ module.us-east-1 ]
    providers = {
      aws = aws.us-west-1
    }


    tgw-peering_attachment_id = local.tgw-peering-id-us-west-1
    tgw-route_table_id        = local.tgw-rt-id-us-west-1
  
}
