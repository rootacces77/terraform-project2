
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


#CloudWatch POLICY ATTACHMENT
resource "aws_iam_role_policy_attachment" "cw_agent" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

#S3 POLICY ATTACHMENT
resource "aws_iam_role_policy_attachment" "s3_fullaccess" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#SNS POLICY ATTACHMENT
resource "aws_iam_role_policy_attachment" "sns_fullaccess" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

#WAF POLICY ATTACHMENT
resource "aws_iam_role_policy_attachment" "waf_fullaccess" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AWSWAFFullAccess"
}
