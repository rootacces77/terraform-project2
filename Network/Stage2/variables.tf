terraform {
  backend "s3" {
    bucket         = "tf-state-project-practice77"
    key            = "accounts/network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-locks"
    encrypt        = true
  }
}