resource "aws_cloudfront_distribution" "note_app_cfront" {
  enabled = true
  default_root_object = "index.html"

  origin {
    origin_id                = aws_s3_bucket.static_pages.id
    domain_name              = aws_s3_bucket.static_pages.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.note_app_oac.id
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.static_pages.id
    viewer_protocol_policy = "redirect-to-https"
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "403"
    response_code         = "200"
    response_page_path    = "/"
  }
}

resource "aws_cloudfront_origin_access_control" "note_app_oac" {
  name                              = aws_s3_bucket.static_pages.bucket_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

output "cfront_domain_name" {
  value = aws_cloudfront_distribution.note_app_cfront.domain_name
}