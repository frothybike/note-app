data "aws_acm_certificate" "namabanana" {
  domain   = "*.namabanana.com"
  statuses = ["ISSUED"]
  provider = aws.virginia
}

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

  origin {
    origin_id   = aws_api_gateway_rest_api.send_mail_api.id
    domain_name = "22fm1a0bc1.execute-api.ap-northeast-1.amazonaws.com"
    origin_path = "/v1"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  aliases = [
    "www.namabanana.com",
  ]

  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.namabanana.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
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

  ordered_cache_behavior {
    path_pattern           = "/api/send"
    target_origin_id       = aws_api_gateway_rest_api.send_mail_api.id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods  = ["HEAD", "GET", "OPTIONS"]

    forwarded_values {
      query_string = true
      headers      = ["Authorization"]

      cookies {
        forward = "all"
      }
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