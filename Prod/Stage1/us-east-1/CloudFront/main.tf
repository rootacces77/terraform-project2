
#############################
# Origin Access Control (OAC)
#############################
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "oac-s3-cf-origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

############################
# CloudFront Distribution
############################

data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "all_viewer_except_host" {
  name = "Managed-AllViewerExceptHostHeader"
}

resource "aws_cloudfront_distribution" "this" {
  enabled         = true
  is_ipv6_enabled = true

  # If you use custom domains, set aliases; otherwise leave empty.
  aliases = var.aliases

  default_root_object = var.default_root_object
  price_class         = var.price_class

  ##########################################
  # Origin 1: S3
  ##########################################

  origin {
    domain_name              = var.s3_origin_bucket_regional_domain_name
    origin_id                = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  ##########################################
  # Origin 2: API Gateway (custom origin)
  ##########################################
  origin {
    domain_name = var.apigw_invoke_domain_name
    origin_id   = "apigw-origin"

    # IMPORTANT:
    # REST API invoke URL is ...amazonaws.com/<stage>
    # CloudFront origin_path prepends "/<stage>" to origin requests.
    origin_path = "/${var.apigw_stage_name}"

    custom_header {
      name  = var.apigw_origin_verify_header_name
      value = var.apigw_origin_verify_secret
    }

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/submit*"
    target_origin_id = "apigw-origin"

    viewer_protocol_policy = "https-only"
    compress               = true

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }


  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "https-only" # Strict: HTTPS only (no HTTP redirect)
    compress               = true

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    # Caching (you can tune these)
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

  # Good defaults
  http_version = "http2and3"

  # Optional: if you want CloudFront to serve a friendly error page for missing routes
  # (often used for SPA routing). Uncomment if needed.
  #
  # custom_error_response {
  #   error_code            = 403
  #   response_code         = 200
  #   response_page_path    = "/index.html"
  #   error_caching_min_ttl = 0
  # }
  #
  # custom_error_response {
  #   error_code            = 404
  #   response_code         = 200
  #   response_page_path    = "/index.html"
  #   error_caching_min_ttl = 0
  # }

  tags = {
    Name      = "CF"
    Terraform = "true"
  }
}