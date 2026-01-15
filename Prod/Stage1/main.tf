module "us-east-1" {
    source = "./us-east-1"

    providers = {
      aws = aws.us-east-1
    }

    domain_zone_id = local.zone_id
  
}