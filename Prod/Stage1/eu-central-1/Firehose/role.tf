############################################
# IAM Assume Role Policy for Firehose
############################################

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

############################################
# Firehose A Role + Policy
############################################

resource "aws_iam_role" "firehose_a" {
  name               = "${var.name_prefix}-firehose-a-role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

data "aws_iam_policy_document" "firehose_a_policy" {
  # Read from Kinesis Stream A
  statement {
    sid    = "ReadFromKinesisStreamA"
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards",
      "kinesis:ListStreams"
    ]
    resources = [var.kinesis_stream_a_arn]
  }

  # Write to S3 Bucket A
  statement {
    sid    = "WriteToS3BucketA"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      var.bucket_A_arn,
      "${var.bucket_A_arn}/*"
    ]
  }

  # CloudWatch Logs (optional but recommended)
  statement {
    sid    = "AllowCWLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "firehose_a_inline" {
  name   = "${var.name_prefix}-firehose-a-inline"
  role   = aws_iam_role.firehose_a.id
  policy = data.aws_iam_policy_document.firehose_a_policy.json
}

############################################
# Firehose B Role + Policy
############################################

resource "aws_iam_role" "firehose_b" {
  name               = "${var.name_prefix}-firehose-b-role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

data "aws_iam_policy_document" "firehose_b_policy" {
  # Read from Kinesis Stream B
  statement {
    sid    = "ReadFromKinesisStreamB"
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards",
      "kinesis:ListStreams"
    ]
    resources = [var.kinesis_stream_b_arn]
  }

  # Write to S3 Bucket B
  statement {
    sid    = "WriteToS3BucketB"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      var.bucket_B_arn,
      "${var.bucket_B_arn}/*"
    ]
  }

  # CloudWatch Logs (optional but recommended)
  statement {
    sid    = "AllowCWLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "firehose_b_inline" {
  name   = "${var.name_prefix}-firehose-b-inline"
  role   = aws_iam_role.firehose_b.id
  policy = data.aws_iam_policy_document.firehose_b_policy.json
}
