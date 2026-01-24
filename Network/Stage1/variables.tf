data "terraform_remote_state" "management" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/management/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/network/terraform.tfstate"
    region = "us-east-1"
  }
}


locals {
  network_account_id = data.terraform_remote_state.management.outputs.network_account_id
  prod_account_id = data.terraform_remote_state.management.outputs.prod_account_id
  vpc_1_us_east_1_cidr = data.terraform_remote_state.network.outputs.vpc_1_us_east_1_cidr
}
