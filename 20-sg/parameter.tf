resource "aws_ssm_parameter" "mysql_sg_id" {
    name  = "/${var.project_name}/${var.environment}/mysql-sg-id"
    type  = "String"
    value = module.mysql_sg.sg_id

    tags = merge(
    var.common_tags,
    var.parameter_tags,
        {
            Name = "${var.project_name}-${var.environment}-mysql-sg-id"
        }
    )
}

resource "aws_ssm_parameter" "backend_sg_id" {
    name  = "/${var.project_name}/${var.environment}/backend-sg-id"
    type  = "String"
    value = module.backend_sg.sg_id

    tags = merge(
    var.common_tags,
    var.parameter_tags,
        {
            Name = "${var.project_name}-${var.environment}-backend-sg-id"
        }
    )
}

resource "aws_ssm_parameter" "app_alb_sg_id" {
    name  = "/${var.project_name}/${var.environment}/app-alb-sg-id"
    type  = "String"
    value = module.app_alb_sg.sg_id

    tags = merge(
    var.common_tags,
    var.parameter_tags,
        {
            Name = "${var.project_name}-${var.environment}-app-alb-sg-id"
        }
    )
}

resource "aws_ssm_parameter" "frontend_sg_id" {
    name  = "/${var.project_name}/${var.environment}/frontend-sg-id"
    type  = "String"
    value = module.frontend_sg.sg_id

    tags = merge(
    var.common_tags,
    var.parameter_tags,
        {
            Name = "${var.project_name}-${var.environment}-frontend-sg-id"
        }
    )
}

resource "aws_ssm_parameter" "web_alb_sg_id" {
    name  = "/${var.project_name}/${var.environment}/web-alb-sg-id"
    type  = "String"
    value = module.web_alb_sg.sg_id

    tags = merge(
    var.common_tags,
    var.parameter_tags,
        {
            Name = "${var.project_name}-${var.environment}-web-alb-sg-id"
        }
    )
}

resource "aws_ssm_parameter" "bastion_sg_id" {
    name  = "/${var.project_name}/${var.environment}/bastion-sg-id"
    type  = "String"
    value = module.bastion_sg.sg_id

    tags = merge(
    var.common_tags,
    var.parameter_tags,
        {
            Name = "${var.project_name}-${var.environment}-bastion-sg-id"
        }
    )
}

resource "aws_ssm_parameter" "ansible_sg_id" {
    name  = "/${var.project_name}/${var.environment}/ansible-sg-id"
    type  = "String"
    value = module.ansible_sg.sg_id

    tags = merge(
    var.common_tags,
    var.parameter_tags,
        {
            Name = "${var.project_name}-${var.environment}-ansible-sg-id"
        }
    )
}

resource "aws_ssm_parameter" "vpn_sg_id" {
    name  = "/${var.project_name}/${var.environment}/vpn-sg-id"
    type  = "String"
    value = module.vpn_sg.sg_id

    tags = merge(
    var.common_tags,
    var.parameter_tags,
        {
            Name = "${var.project_name}-${var.environment}-vpn-sg-id"
        }
    )
}
