resource "aws_dynamodb_table" "kv" {
  name         = local.table_name
  billing_mode = "PAY_PER_REQUEST" # on-demand (no capacity planning)

  # Key-value: Partition key only
  hash_key = "pk"

  attribute {
    name = "pk"
    type = "S"
  }

  # Optional: TTL (useful if you want items to expire automatically)
  # If you want TTL, set ttl attribute on items, e.g. ttl = 1736899200 (epoch seconds)
  ttl {
    attribute_name = "ttl"
    enabled        = false
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = local.table_name
    Environment = "PROD"
    Terraform   = "true"
  }
}