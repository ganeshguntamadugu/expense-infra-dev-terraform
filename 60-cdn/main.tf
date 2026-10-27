resource "aws_cloudfront_distribution" "expense" {
  origin {
    domain_name              = "${local.instance_name}.${var.zone_name}"
    origin_id                = "${local.instance_name}-cdn"
    custom_origin_config{
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled             = true
  aliases = ["${var.project_name}-cdn.${var.zone_name}"]

# Dynamic content, evaluated at last no cache
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.instance_name}-cdn"

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    cache_policy_id        = data.aws_cloudfront_cache_policy.no_cache.id
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/image/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${local.instance_name}-cdn"

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true

    cache_policy_id        = data.aws_cloudfront_cache_policy.cache_optimized.id
    
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${local.instance_name}-cdn"

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true

    cache_policy_id        = data.aws_cloudfront_cache_policy.cache_optimized.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA", "GB", "DE"]
    }
  }

  tags = merge(
        var.common_tags,
        var.cdn_tags,
        {
            Name = "${local.instance_name}-cdn"
        }
    )

  viewer_certificate {
    acm_certificate_arn = data.aws_ssm_parameter.https_certificate_id.value
    ssl_support_method  = "sni-only"
  }
}
