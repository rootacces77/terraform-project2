variable "glue_database_name" {
    type = string
    description = "Name of Glue database"
    default = "athena-db"
  
}

variable "s3_targets" {
    type = list(string)
    description = "S3 URI's"
  
}

variable "s3_bucket_names" {
    type = list(string)
    description = "List of S3 bucket names"
  
}