resource "aws_cloudfront_function" "index_document_function" {
  name    = "index-document-function"
  runtime = "cloudfront-js-2.0"
  comment = "index document function"
  publish = true
  code    = file("${path.module}/index-document-function.js")
}

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
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.index_document_function.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
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