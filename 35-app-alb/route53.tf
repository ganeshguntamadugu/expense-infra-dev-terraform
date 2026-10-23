#Route53
resource "aws_route53_record" "app_alb" {
  zone_id = data.aws_route53_zone.expense.zone_id
  name    = "*.app-${var.environment}"
  type    = "A"
  #ttl     = 1
  allow_overwrite = true

  alias {
    name                   = module.app_alb.dns_name
    zone_id                = module.app_alb.zone_id
    evaluate_target_health = true
  }
}