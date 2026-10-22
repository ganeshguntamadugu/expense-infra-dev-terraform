#Route53
resource "aws_route53_record" "web_alb" {
  zone_id = data.aws_route53_zone.expense.zone_id
  name    = "expense-${var.environment}"
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = module.web_alb.dns_name
    zone_id                = module.web_alb.zone_id
    evaluate_target_health = true
  }
}