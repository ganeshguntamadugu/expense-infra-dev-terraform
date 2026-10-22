resource "aws_acm_certificate" "gangs" {
  domain_name       = "*.${var.zone_name}"
  validation_method = "DNS"

  tags = merge(
        var.common_tags,
        var.acm_tags,
        {
            Name = "${local.instance_name}-acm"
        }
    )
}

resource "aws_route53_record" "gangs" {
  for_each = {
    for dvo in aws_acm_certificate.gangs.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 1
  type            = each.value.type
  zone_id         = data.aws_route53_zone.expense.zone_id
}

resource "aws_acm_certificate_validation" "gangs" {
  certificate_arn         = aws_acm_certificate.gangs.arn
  validation_record_fqdns = [for record in aws_route53_record.gangs : record.fqdn]
}