# Create Route53 records for the CloudFront distribution aliases
resource "aws_route53_record" "cdn" {
  zone_id = data.aws_route53_zone.expense.zone_id
  name    = "expense-cdn"
  type    = "A"
  #ttl     = 1
  allow_overwrite = true

  alias {
    name                   = aws_cloudfront_distribution.expense.domain_name
    zone_id                = aws_cloudfront_distribution.expense.hosted_zone_id
    evaluate_target_health = false
  }
}