module "us_east_1" {

    providers = {
      aws = aws.us-east-1
    }


    source = "./us-east-1"

    prod_account_id = local.prod_account_id
  
}

/*
module "us_west_1" {

    providers = {
      aws = aws.us_west_1
    }
    source = "./us_west_1"
    depends_on = [ module.us_east_1 ]

    prod_account_id = local.prod_account_id
    us_east_1_tgw_id = module.us_east_1.tgw_id
  
}

module "eu_central_1" {

    providers = {
      aws = aws.eu_central_1
    }
    source = "./eu_central_1"
    depends_on = [ module.us_west_1 ]

    prod_account_id = local.prod_account_id
    us_east_1_tgw_id = module.us_east_1.tgw_id
  
}
*/