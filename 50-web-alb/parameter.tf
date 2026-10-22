resource "aws_ssm_parameter" "web_alb_listerner_id" {
    name  = "/${var.project_name}/${var.environment}/web-alb-listerner-id"
    type  = "String"
    value = aws_lb_listener.https.arn

    tags = merge(
    var.common_tags,
    var.parameter_tags,
        {
            Name = "${var.project_name}-${var.environment}-web-alb-listerner-id"
        }
    )
}