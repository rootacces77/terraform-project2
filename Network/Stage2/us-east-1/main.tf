module "tgw" {
    source = "./TGW"

    tgw-peering-id-eu-central-1 = var.tgw-peering-id-eu-central-1
    tgw-peering-id-us-west-1    = var.tgw-peering-id-us-west-1
    tgw-rt-id                   = var.tgw-rt-id
    vpc-eu-central-1-cidr       = var.vpc-eu-central-1-cidr
    vpc-us-west-1-cidr          = var.vpc-us-west-1-cidr
  
}

module "routes" {
    source = "./ROUTES"

    vpc-1-vpn-rt-id       = var.vpc-1-vpn-rt-id
    vpc-eu-central-1-cidr = var.vpc-eu-central-1-cidr
    vpc-us-west-1-cidr    = var.vpc-us-west-1-cidr
    tgw-id                = var.tgw-id

  
}


module "NetworkManager" {
    source = "./NetworkManager"
    
    tgw_arn_eu_central_1 = var.tgw_arn_eu_central_1
    tgw_arn_us_east_1 = var.tgw_arn_us_east_1
    tgw_arn_us_west_1 = var.tgw_arn_us_west_1

} 