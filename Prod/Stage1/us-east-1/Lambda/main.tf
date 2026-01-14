
############################################
# IAM Role for Lambda
############################################
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# CloudWatch Logs permissions
resource "aws_iam_role_policy_attachment" "lambda_basic_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# DynamoDB write permission
data "aws_iam_policy_document" "lambda_dynamodb" {
  statement {
    sid    = "AllowWriteToTable"
    effect = "Allow"
    actions = [
      "dynamodb:PutItem"
    ]
    resources = [var.dynamodb_table_arn]
  }
}

resource "aws_iam_policy" "lambda_dynamodb" {
  name   = "lambda-policy-ddb"
  policy = data.aws_iam_policy_document.lambda_dynamodb.json
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_dynamodb.arn
}


############################################
# Lambda Function
############################################

resource "aws_lambda_function" "writer" {
  function_name = local.lambda_name
  role          = aws_iam_role.lambda_exec.arn

  runtime = "python3.12"
  handler = "lambda.handler" # because your file is lambda.py and function is handler()

  # Code from S3 (must be a ZIP)
  s3_bucket         = var.lambda_bucket_name
  s3_key            = var.lambda_zip_path
 # s3_object_version = var.lambda_artifact_version

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name
      ORIGIN_VERIFY_HEADER  = var.apigw_origin_verify_header_name
      ORIGIN_VERIFY_SECRET  = var.apigw_origin_verify_secret
    }
  }

  timeout     = 10
  memory_size = 128
}