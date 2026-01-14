locals {
  lambda_name = "main"
}

variable "dynamodb_table_arn" {
    type = string
    description = "DynamoDB table arn"
  
}

variable "dynamodb_table_name" {
    type = string
    description = "DynamoDB table name"
  
}

variable "lambda_bucket_name" {
    type = string
    description = "Lambda bucket name"
  
}

variable "lambda_zip_path" {
    type = string
    description = "Lambda path to zip file"
  
}

/*
variable "lambda_object_version" {

  
} */

variable "apigw_origin_verify_header_name" {
    type = string
    description = "Header Key"
  
}

variable "apigw_origin_verify_secret" {
     type = string
     description = "Header value"
  
}