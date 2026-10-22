resource "aws_ssm_parameter" "app_alb_listerner_id" {
    name  = "/${var.project_name}/${var.environment}/app-alb-listerner-id"
    type  = "String"
    value = aws_lb_listener.http.arn

    tags = merge(
    var.common_tags,
    var.parameter_tags,
        {
            Name = "${var.project_name}-${var.environment}-app-alb-listerner-id"
        }
    )
}