variable "bucket_name" {
    type = string
    description = "Name of the bucket"
    default = "static-website-312345123"
}

locals {
  website_dir   = "${path.module}/website"
  website_files = fileset(local.website_dir, "**/*")

  lambda_dir   = "${path.module}/lambda"
  lambda_files = fileset(local.lambda_dir, "**/*")
}

/*
variable "website_dir" {
    type = string
    description = "Dir of the website files"
    default = "${path.module}/website"
}
*/

