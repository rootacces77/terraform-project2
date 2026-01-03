

data "terraform_remote_state" "management-s1" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/management/terraform.tfstate"
    region = "us-east-1"
  }
}


data "terraform_remote_state" "network-s1" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/network/terraform.tfstate"
    region = "us-east-1"
  }
}


locals {
  network_account_id          = data.terraform_remote_state.management-s1.outputs.network_account_id
  prod_account_id             = data.terraform_remote_state.management-s1.outputs.prod_account_id

  tgw-peering-id-eu-central-1 = data.terraform_remote_state.network-s1.outputs.tgw-peering-id-eu-central-1
  tgw-rt-id-eu-central-1      = data.terraform_remote_state.network-s1.outputs.tgw-rt-id-eu-central-1

  tgw-peering-id-us-west-1    = data.terraform_remote_state.network-s1.outputs.tgw-peering-id-us-west-1
  tgw-rt-id-us-west-1         = data.terraform_remote_state.network-s1.outputs.tgw-rt-id-us-west-1

  tgw-id-us-east-1            = data.terraform_remote_state.network-s1.outputs.tgw-id-us-east-1
  tgw-rt-id-us-east-1         = data.terraform_remote_state.network-s1.outputs.tgw-rt-id-us-east-1

  vpc1-vpn-rt-id-us-east-1    = data.terraform_remote_state.network-s1.outputs.vpc1-vpn-rt-id-us-east-1 
  vpc-cidr-eu-central-1       = data.terraform_remote_state.network-s1.outputs.vpc-cidr-eu-central-1
  vpc-cidr-us-west-1          = data.terraform_remote_state.network-s1.outputs.vpc-cidr-us-west-1

  tgw-arn-us-east-1           = data.terraform_remote_state.network-s1.outputs.tgw-arn-us-east-1
  tgw-arn-us-west-1           = data.terraform_remote_state.network-s1.outputs.tgw-arn-us-west-1
  tgw-arn-eu-central-1        = data.terraform_remote_state.network-s1.outputs.tgw-arn-eu-central-1

}


