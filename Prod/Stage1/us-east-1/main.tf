module "acm" {
    source = "./ACM"

    domain_zone_id = var.domain_zone_id
  
}

module "s3" {
    source = "./S3"
  
}

module "dynamodb" {
    source = "./DynamoDB"
  
}

module "lambda" {
    source = "./Lambda"

    dynamodb_table_arn              = module.dynamodb.dynamodb_table_arn
    dynamodb_table_name             = module.dynamodb.dynamodb_table_name

    apigw_origin_verify_header_name = var.apigw_origin_verify_header_name
    apigw_origin_verify_secret      = var.apigw_origin_verify_secret

    lambda_bucket_name              = module.s3.lambda_bucket_name
    lambda_zip_path                 = "lambda.zip"


  
}

module "apigateway" {
    source = "./APIGateway"

    lambda_function_name = module.lambda.lambda_function_name
    lambda_invoke_arn    = module.lambda.lambda_invoke_arn
  
}

module "cf" {
    source = "./CloudFront"

    acm_certificate_arn                   = module.acm.cert_arn

    s3_cf_origin_arn                      = module.s3.s3_cf_origin_arn
    s3_cf_origin_id                       = module.s3.s3_cf_origin_id
    s3_origin_bucket_regional_domain_name = module.s3.s3_cf_origin_regional_domain_name

    apigw_origin_verify_header_name       = var.apigw_origin_verify_header_name
    apigw_origin_verify_secret            = var.apigw_origin_verify_secret
    apigw_invoke_domain_name              = module.apigateway.apigw_invoke_domain_name
    apigw_stage_name                      = module.apigateway.api_gateway_stage_name
  
}
