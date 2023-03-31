locals {
  aliases                    = length(var.aliases) != 0 ? var.aliases : [var.fqdn]
  web_acl_id                 = var.make_distribution_private != true ? var.web_acl_id : data.aws_wafv2_web_acl.private.arn
  ssl_certificate_arn        = var.ssl_certificate_arn != "" ? var.ssl_certificate_arn : module.certificate[0].certificate_arn
  // must consult this doc for proper region endpoint formatting https://docs.aws.amazon.com/general/latest/gr/s3.html#s3_website_region_endpoints
  s3_bucket_website_endpoint = var.create_s3_origin != true ? "${var.s3_bucket_name}.s3-website-${var.s3_bucket_region}.amazonaws.com" : module.s3[0].bucket_regional_domain_name
}

resource "aws_cloudfront_distribution" "main" {
  provider     = aws.cloudfront
  http_version = "http2"

  origin {
    origin_id   = "origin-${var.fqdn}"
    domain_name = local.s3_bucket_website_endpoint
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  enabled = true

  aliases = local.aliases

  price_class = "PriceClass_100"
  default_root_object = var.index_document

  default_cache_behavior {
    target_origin_id = "origin-${var.fqdn}"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    response_headers_policy_id = var.response_headers_policy_id
    viewer_protocol_policy     = var.viewer_protocol_policy
    min_ttl                    = 0
    default_ttl                = 300
    max_ttl                    = 1200
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = local.ssl_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = var.minimum_protocol_version
  }

  web_acl_id = local.web_acl_id
}
