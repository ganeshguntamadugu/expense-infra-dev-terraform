data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc-id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public-subnet-ids"
}

data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/web-alb-sg-id"
}

data "aws_ssm_parameter" "https_certificate_id" {
  name = "/${var.project_name}/${var.environment}/https_certificate_id"
}

data "aws_route53_zone" "expense" {
  name         = "gangs.shop"
}