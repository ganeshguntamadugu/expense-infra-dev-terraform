locals {
    instance_name = "${var.project_name}-${var.environment}"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
    web_alb_sg_id = data.aws_ssm_parameter.web_alb_sg_id.value 
    https_certificate_id = data.aws_ssm_parameter.https_certificate_id.value 
}