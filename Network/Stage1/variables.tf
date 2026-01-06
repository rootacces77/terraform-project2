data "terraform_remote_state" "management" {
  backend = "s3"
  config = {
    bucket = "tf_state_project_practice77"
    key    = "accounts/management/terraform.tfstate"
    region = "us-east-1"
  }
}


locals {
  network_account_id = data.terraform_remote_state.management.outputs.network_account_id
  prod_account_id = data.terraform_remote_state.management.outputs.prod_account_id
}
