module "web_alb" {
  source = "terraform-aws-modules/alb/aws"

  internal = false
  name    = "${local.instance_name}-web-alb"
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_id
  security_groups = [local.web_alb_sg_id]
  create_security_group = false
  enable_deletion_protection = false

  tags = merge(
        var.common_tags,
        var.web_alb_tags,
        {
            Name = "${local.instance_name}-web-alb"
        }
    )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello I'm from Frontend ALB</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.https_certificate_id

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello I'm from Frontend ALB</h1>"
      status_code  = "200"
    }
  }
}