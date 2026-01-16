module "destA_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket        = "destA-bucket-1231412456"
  force_destroy = true

  # Recommended when using CloudFront as the only public entry point
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Strong defaults
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  # Optional: serve index.html / error.html via CloudFront (recommended approach)
  # NOTE: This does NOT create a public "website endpoint"; CloudFront will request objects like /index.html
  tags = {
    Name        = "destA-bucket"
    Environment = "PROD"
    Terraform   = "true"
  }
}
