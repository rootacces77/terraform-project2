

data "terraform_remote_state" "management_s1" {
  backend = "s3"
  config = {
    bucket = "tf_state_project_practice77"
    key    = "accounts/management/terraform.tfstate"
    region = "us-east-1"
  }
}


data "terraform_remote_state" "network_s1" {
  backend = "s3"
  config = {
    bucket = "tf_state_project_practice77"
    key    = "accounts/network/terraform.tfstate"
    region = "us-east-1"
  }
}


locals {
  network_account_id          = data.terraform_remote_state.management_s1.outputs.network_account_id
  prod_account_id             = data.terraform_remote_state.management_s1.outputs.prod_account_id

  tgw_peering_id_eu_central_1 = data.terraform_remote_state.network_s1.outputs.tgw_peering_id_eu_central_1
  tgw_rt_id_eu_central_1      = data.terraform_remote_state.network_s1.outputs.tgw_rt_id_eu_central_1

  tgw_peering_id_us_west_1    = data.terraform_remote_state.network_s1.outputs.tgw_peering_id_us_west_1
  tgw_rt_id_us_west_1         = data.terraform_remote_state.network_s1.outputs.tgw_rt_id_us_west_1

  tgw_id_us_east_1            = data.terraform_remote_state.network_s1.outputs.tgw_id_us_east_1
  tgw_rt_id_us_east_1         = data.terraform_remote_state.network_s1.outputs.tgw_rt_id_us_east_1

  vpc1_vpn_rt_id_us_east_1    = data.terraform_remote_state.network_s1.outputs.vpc1_vpn_rt_id_us_east_1 
  vpc_cidr_eu_central_1       = data.terraform_remote_state.network_s1.outputs.vpc_cidr_eu_central_1
  vpc_cidr_us_west_1          = data.terraform_remote_state.network_s1.outputs.vpc_cidr_us_west_1

  tgw_arn_us_east_1           = data.terraform_remote_state.network_s1.outputs.tgw_arn_us_east_1
  tgw_arn_us_west_1           = data.terraform_remote_state.network_s1.outputs.tgw_arn_us_west_1
  tgw_arn_eu_central_1        = data.terraform_remote_state.network_s1.outputs.tgw_arn_eu_central_1

}


