#Route53
module "route53" {
    source = "../../terraform-aws-route53"
    zone_id = data.aws_route53_zone.expense.zone_id
    zone_name = var.zone_name 
    allow_overwrite = true

    route53_records = {
        mysql = {
            name    = "mysql"
            type    = "A"
            ttl     = 1
            records = [module.mysql_ec2_instance.private_ip]
        }
        backend = {
            name    = "backend"
            type    = "A"
            ttl     = 1
            records = [module.backend_ec2_instance.private_ip]
        }
        frontend = {
            name    = "frontend"
            type    = "A"
            ttl     = 1
            records = [module.frontend_ec2_instance.private_ip]
        }
        frontend_public = {
            name    = ""
            type    = "A"
            ttl     = 1
            records = [module.frontend_ec2_instance.public_ip]
        }
    }
}