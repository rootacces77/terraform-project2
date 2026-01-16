/*
module "us-east-1" {
    source = "./us-east-1"

    providers = {
      aws = aws.us-east-1
    }

    domain_zone_id = local.zone_id
}

*/

module "eu-central-1" {
  source = "./eu-central-1"

  providers = {
      aws = aws.eu-central-1
    }  
  
}