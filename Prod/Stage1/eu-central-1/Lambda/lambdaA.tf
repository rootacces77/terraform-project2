
############################################
# LambdaA Function
############################################

resource "aws_lambda_function" "writerA" {
  function_name = local.lambdaA_name
  role          = aws_iam_role.lambda_exec.arn

  runtime = "python3.12"
  handler = "lambda.handler" # because your file is lambda.py and function is handler()

  # Code from S3 (must be a ZIP)
  s3_bucket         = var.lambda_bucket_name
  s3_key            = var.lambdaA_zip_path
 # s3_object_version = var.lambda_artifact_version

  environment {
    variables = {
       STREAM_NAME = var.kinesis_streamA_name
    }
  }

  timeout     = 10
  memory_size = 128
}