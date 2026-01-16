locals {

  lambda_dir   = "${path.module}/lambda"
  lambda_files = fileset(local.lambda_dir, "**/*")
}
