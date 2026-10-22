resource "aws_ssm_parameter" "https_certificate_id" {
    name  = "/${var.project_name}/${var.environment}/https_certificate_id"
    type  = "String"
    value = aws_acm_certificate.gangs.arn

    tags = merge(
    var.common_tags,
    var.parameter_tags,
        {
            Name = "${var.project_name}-${var.environment}-https_certificate_id"
        }
    )
}