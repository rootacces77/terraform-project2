
############################################
# Lambda Function
############################################

resource "aws_lambda_function" "waf_ip_ban" {
  function_name = "waf-ip-ban"
  role          = aws_iam_role.lambda_exec.arn

  runtime = "python3.12"
  handler = "lambda.lambda_handler" # because your file is lambda.py and function is lambda_handler()

  # Code from S3 (must be a ZIP)
  s3_bucket         = var.scripts_s3_bucket_name
  s3_key            = var.lambda_zip_path

  environment {
    variables = {
        WAF_SCOPE = REGIONAL
        WAF_REGION = us-west-1
        WAF_IP_SET_ID = 
        WAF_IP_SET_NAME =
        SNS_TOPIC_ARN =
    }
  }

  timeout     = 10
  memory_size = 128
}