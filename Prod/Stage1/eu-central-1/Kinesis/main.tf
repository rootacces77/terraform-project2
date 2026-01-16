############################################
# Kinesis Streams
############################################

resource "aws_kinesis_stream" "lambdaA" {
  name             = var.kinesis_streamA_name
  retention_period = var.kinesis_retention_hours

  stream_mode_details {
    stream_mode = "ON_DEMAND" # "ON_DEMAND" or "PROVISIONED"
  }

  # Only used when stream_mode = "PROVISIONED"
  # shard_count = var.kinesis_stream_mode == "PROVISIONED" ? var.kinesis_shard_count : null

  # Optional: enable server-side encryption with AWS-managed KMS key (alias/aws/kinesis)
  #encryption_type = var.kinesis_enable_sse ? "KMS" : null
  # kms_key_id      = var.kinesis_enable_sse ? "alias/aws/kinesis" : null

  tags = {
    Name   = var.kinesis_streamA_name
    Source = "lambdaA"
  }
}

resource "aws_kinesis_stream" "lambdaB" {
  name             = var.kinesis_streamB_name
  retention_period = var.kinesis_retention_hours

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  #shard_count = var.kinesis_stream_mode == "PROVISIONED" ? var.kinesis_shard_count : null

  #encryption_type = var.kinesis_enable_sse ? "KMS" : null
  #kms_key_id      = var.kinesis_enable_sse ? "alias/aws/kinesis" : null

  tags = {
    Name   = var.kinesis_streamB_name
    Source = "lambdaB"
  }
}