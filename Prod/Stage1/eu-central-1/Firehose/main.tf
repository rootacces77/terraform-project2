
############################################
# Firehose Delivery Streams
############################################

resource "aws_kinesis_firehose_delivery_stream" "a" {
  name        = "${var.name_prefix}-firehose-a"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = var.kinesis_stream_a_arn
    role_arn           = aws_iam_role.firehose_a.arn
  }

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_a.arn
    bucket_arn = var.bucket_A_arn
    prefix     = var.name_prefix

    buffering_size     = 5   # MiB
    buffering_interval = 300 # seconds

    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${var.name_prefix}-firehose-a"
      log_stream_name = "S3Delivery"
    }
  }

  tags = {Name = "Firehose A"}
}

resource "aws_kinesis_firehose_delivery_stream" "b" {
  name        = "${var.name_prefix}-firehose-b"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = var.kinesis_stream_b_arn
    role_arn           = aws_iam_role.firehose_b.arn
  }

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_b.arn
    bucket_arn = var.bucket_B_arn
    prefix     = var.name_prefix

    buffering_size     = 5
    buffering_interval = 300

    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${var.name_prefix}-firehose-b"
      log_stream_name = "S3Delivery"
    }
  }

  tags = {Name = "Firehose B"}
}