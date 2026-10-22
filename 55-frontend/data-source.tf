data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc-id"
}

data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project_name}/${var.environment}/frontend-sg-id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public-subnet-ids"
}

data "aws_ssm_parameter" "web_alb_listerner_id" {
  name = "/${var.project_name}/${var.environment}/web-alb-listerner-id"
}

data "aws_ami" "expense" {
    most_recent      = true
    owners = ["973714476881"]

    filter {
        name = "name"
        values = ["Redhat-9-DevOps-Practice"]
    }

    filter {
        name = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}