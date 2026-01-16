locals {
  lambdaA_name = "LambdaA"
  lambdaB_name = "LambdaB"
}

variable "lambda_bucket_name" {
    type = string
    description = "Lambda bucket name"
  
}

variable "lambdaA_zip_path" {
    type = string
    description = "LambdaA path to zip file"
  
}

variable "lambdaB_zip_path" {
    type = string
    description = "LambdaB path to zip file"
  
}

variable "kinesis_streamA_arn" {
    type = string
    description = "Kinesis StreamA ARN"
  
}

variable "kinesis_streamB_arn" {
    type = string
    description = "Kinesis StreamB ARN"
  
}