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

# Kinesis write permission
data "aws_iam_policy_document" "lambda_kinesis" {
  statement {
    sid    = "AllowWriteToKinesisStream"
    effect = "Allow"
    actions = [
      "kinesis:PutRecord",
      "kinesis:PutRecords"
    ]
    resources = [var.kinesis_streamA_arn,var.kinesis_streamB_arn]
  }
}

resource "aws_iam_policy" "lambda_kinesis" {
  name   = "lambda-policy-kinesis"
  policy = data.aws_iam_policy_document.lambda_kinesis.json
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_kinesis.arn
}

