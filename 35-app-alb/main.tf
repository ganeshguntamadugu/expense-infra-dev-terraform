module "app_alb" {
  source = "terraform-aws-modules/alb/aws"

  internal = true
  name    = "${local.instance_name}-app-alb"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_id
  security_groups = [local.app_alb_sg_id]
  create_security_group = false
  enable_deletion_protection = false

  tags = merge(
        var.common_tags,
        var.app_alb_tags,
        {
            Name = "${local.instance_name}-app-alb"
        }
    )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello I'm from Backend ALB</h1>"
      status_code  = "200"
    }
  }
}
