output "lambda_s3_arn" {
    value = module.lambda_bucket.s3_bucket_arn
  
}

output "lambda_s3_bucket_name" {
    value = module.lambda_bucket.name
  
}

output "destA_s3_arn" {
    value = module.destA_bucket.s3_bucket_arn
  
}

output "destB_s3_arn" {
    value = module.destB_bucket.s3_bucket_arn
  
}