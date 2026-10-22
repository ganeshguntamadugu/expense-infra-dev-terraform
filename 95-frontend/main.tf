module "frontend_ec2_instance" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.expense.id
    name = "${local.instance_name}-frontend"
    instance_type = "t3.micro"

    create_security_group = false
    
    vpc_security_group_ids = [local.frontend_sg_id]
    subnet_id     = local.public_subnet_id

    tags = merge(
        var.common_tags,
        var.frontend_tags,
        {
            Name = "${local.instance_name}-frontend"
        }
    )
}

resource "null_resource" "frontend" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.frontend_ec2_instance.id 
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = module.frontend_ec2_instance.private_ip
  }

   provisioner "file" {
    source      = "frontend.sh"
    destination = "/tmp/frontend.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/frontend.sh",
      "sudo sh /tmp/frontend.sh ${var.frontend_tags.Resource} ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "frontend" {
  instance_id = module.frontend_ec2_instance.id
  state       = "stopped"
  depends_on = [null_resource.frontend]
}

resource "aws_ami_from_instance" "frontend" {
  name               = "${local.instance_name}-frontend"
  source_instance_id = module.frontend_ec2_instance.id
  depends_on = [aws_ec2_instance_state.frontend]
  tags = merge(
        var.common_tags,
        var.frontend_tags,
        {
            Name = "${local.instance_name}-frontend"
        }
    )
}

resource "null_resource" "frontend_delete" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.frontend_ec2_instance.id 
  }

  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "aws ec2 terminate-instances --instance-ids ${module.frontend_ec2_instance.id} --region us-east-1"
  }
  depends_on = [aws_ami_from_instance.frontend]
}

resource "aws_lb_target_group" "frontend" {
  name     = "${local.instance_name}-frontend"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  health_check  {
    healthy_threshold = 3
    unhealthy_threshold = 2
    path = "/"
    timeout = 4
    interval = 5
    matcher = "200-299"
    port = 80
    protocol = "HTTP"
  }
  tags = merge(
        var.common_tags,
        var.target_group_tags,
        {
            Name = "${local.instance_name}-frontend"
        }
    )
}

resource "aws_launch_template" "frontend" {
  name = "${local.instance_name}-frontend"
  update_default_version = true
  image_id = aws_ami_from_instance.frontend.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  instance_initiated_shutdown_behavior = "terminate"
  tag_specifications {
    resource_type = "instance"

    tags = merge(
        var.common_tags,
        var.launch_template_tags,
        {
            Name = "${local.instance_name}-frontend"
        }
    )
  }
}

resource "aws_autoscaling_group" "frontend" {
  name                      = "${local.instance_name}-frontend"
  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [local.public_subnet_id]
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  max_size                  = 10
  min_size                  = 2
  target_group_arns         = [aws_lb_target_group.frontend.arn]
  #force_delete              = true

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

# If the instances are not healthy with in 15m, autoscaling will delete that instance
  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "${local.instance_name}-frontend"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Resource"
    value               = "AutoScaling"
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_policy" "cpu_target" {
  name                   = "cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}


resource "aws_lb_listener_rule" "host_based_routing" {
  listener_arn = local.web_alb_listerner_id
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["expense-${var.environment}.${var.zone_name}"]
    }
  }
}
