data "aws_cloudfront_cache_policy" "no_cache" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "cache_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_ssm_parameter" "https_certificate_id" {
  name = "/${var.project_name}/${var.environment}/https_certificate_id"
}

data "aws_route53_zone" "expense" {
  name         = "gangs.shop"
}