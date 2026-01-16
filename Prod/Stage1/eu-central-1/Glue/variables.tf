locals {
  glue_s3_targets = [
    "s3://${var.destA_bucket_name}/prefix2026/",
    "s3://${var.destB_bucket_name}/prefix2026/"
  ]
}


variable "glue_database_name" {
    type = string
    description = "Name of Glue database"
    default = "athena-db"
  
}

variable "s3_bucket_names" {
    type = list(string)
    description = "List of S3 bucket names"
  
}

variable "destA_bucket_name" {
    type = string
  
}

variable "destB_bucket_name" {
    type = string
  
}