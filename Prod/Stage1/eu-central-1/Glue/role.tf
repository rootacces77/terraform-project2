
############################################
# IAM Role for Glue Crawler
############################################

data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "glue_crawler" {
  name               = "s3-glue-crawler-role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
}

# Minimal S3 read access for crawler + Glue logging
data "aws_iam_policy_document" "glue_crawler_policy" {
  statement {
    sid    = "AllowReadS3Data"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = concat(
      # Buckets
      [for b in var.s3_bucket_names : "arn:aws:s3:::${b}"],
      # Objects
      [for b in var.s3_bucket_names : "arn:aws:s3:::${b}/*"]
    )
  }

  statement {
    sid    = "AllowGlueAndLogs"
    effect = "Allow"
    actions = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "glue_crawler_inline" {
  name   = "s3-glue-crawler-inline"
  role   = aws_iam_role.glue_crawler.id
  policy = data.aws_iam_policy_document.glue_crawler_policy.json
}