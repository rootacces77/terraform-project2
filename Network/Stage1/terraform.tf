terraform {
  backend "s3" {
    bucket         = "tf-state-project-practice77"
    key            = "accounts/network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-locks"
    encrypt        = true
  }
}

provider "aws" {

  alias = "us-east-1"
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::${local.network_account_id}:role/AdminRole"
    session_name = "tf-network"
  }
}

provider "aws" {

  alias = "us-west-1"
  region = "us-west-1"

  assume_role {
    role_arn     = "arn:aws:iam::${local.network_account_id}:role/AdminRole"
    session_name = "tf-network"
  }
}

provider "aws" {

  alias = "eu-central-1"
  region = "eu-central-1"

  assume_role {
    role_arn     = "arn:aws:iam::${local.network_account_id}:role/AdminRole"
    session_name = "tf-network"
  }
}
