module "us-east-1" {

    providers = {
      aws = aws.us-east-1
    }

    source = "./us-east-1"
  
}

module "us-west-1" {

    providers = {
      aws = aws.us-west-1
    }
    source = "./us-west-1"
    depends_on = [ module.us-east-1 ]
  
}

module "eu-central-1" {

    providers = {
      aws = aws.eu-central-1
    }
    source = "./eu-central-1"
    depends_on = [ module.us-west-1 ]
  
}