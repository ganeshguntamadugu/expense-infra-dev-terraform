#Route53
module "route53" {
    source = "../../terraform-aws-route53"
    zone_id = data.aws_route53_zone.expense.zone_id
    zone_name = var.zone_name
    allow_overwrite = true

    route53_records = {
        rds_endpoint = {
            name    = "mysql-${var.environment}"
            type    = "CNAME"
            ttl     = 1
            records = [module.db.db_instance_address]
        }
    }
}