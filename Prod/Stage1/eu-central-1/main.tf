
module "s3" {
    source = "./S3"

}

module "kinesis" {
    source = "./Kinesis"
  
}

module "lambda" {
    source = "./Lambda"

    kinesis_streamA_arn = module.kinesis.kinesis_steam_A_arn
    kinesis_streamB_arn = module.kinesis.kinesis_steam_B_arn

    lambda_bucket_name  = module.s3.lambda_s3_bucket_name

    lambdaA_zip_path    = "lambdaA.zip"
    lambdaB_zip_path    = "lambdaB.zip"
    
}

module "eventBridge" {
    source = "./EventBridge"

    lambdaA_function_name = module.lambda.lambdaA_function_name
    lambdaB_function_name = module.lambda.lambdaB_function_name

    lambdaA_arn           = module.lambda.lambdaA_arn
    lambdaB_arn           = module.lambda.lambdaB_arn
  
}

module "firehose" {
    source = "./Firehose"

    bucket_A_arn         = module.s3.destA_s3_arn
    bucket_B_arn         = module.s3.destB_s3_arn

    kinesis_stream_a_arn = module.kinesis.kinesis_steam_A_arn
    kinesis_stream_b_arn = module.kinesis.kinesis_steam_B_arn


  
}