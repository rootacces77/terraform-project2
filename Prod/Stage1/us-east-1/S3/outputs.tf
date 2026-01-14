output "s3_cf_origin_arn" {
  value = module.static_site_bucket.s3_bucket_arn
}

output "s3_cf_origin_id" {
  value = module.static_site_bucket.s3_bucket_id
}

output "s3_cf_origin_regional_domain_name" {
  value = module.static_site_bucket.s3_bucket_bucket_regional_domain_name
}

output "lambda_bucket_name" {
    value = module.lambda_bucket.s3_bucket_id
  
}