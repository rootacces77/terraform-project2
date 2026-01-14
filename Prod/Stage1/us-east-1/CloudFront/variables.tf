variable "acm_certificate_arn" {
  type        = string
  description = "Existing ACM cert ARN (MUST be in us-east-1 for CloudFront)"
}

variable "aliases" {
  type        = list(string)
  description = "Custom domain names for CloudFront (e.g. [\"app.example.com\"])"
  default     = ["www.project-practice.com"]
}


variable "default_root_object" {
  description = "Default root object for /* requests."
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"
}

variable "s3_cf_origin_arn" {
    type = string
    description = "ARN of S3 bucket used as CF Origin"
  
}

variable "s3_cf_origin_id" {
    type = string
    description = "ID of S3 bucket used as CF Origin"
  
}

variable "s3_origin_bucket_regional_domain_name" {
  description = "S3 bucket regional domain name (REST endpoint), e.g. my-bucket.s3.eu-central-1.amazonaws.com"
  type        = string
}

variable "apigw_invoke_domain_name" {
    type = string
    description = "APIGateway domain name"
  
}

variable "apigw_stage_name" {
    type = string
    description = "APIGateway Stage name"
  
}

variable "apigw_origin_verify_header_name" {
    type = string
    description = "Header Key"
  
}

variable "apigw_origin_verify_secret" {
     type = string
     description = "Header value"
  
}