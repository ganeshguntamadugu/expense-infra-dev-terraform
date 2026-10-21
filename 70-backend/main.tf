module "backend_ec2_instance" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.expense.id
    name = "${local.instance_name}-backend"
    instance_type = "t3.micro"

    create_security_group = false
    
    vpc_security_group_ids = [local.backend_sg_id]
    subnet_id     = local.private_subnet_id

    tags = merge(
        var.common_tags,
        var.backend_tags,
        {
            Name = "${local.instance_name}-backend"
        }
    )
}

resource "null_resource" "backend" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.backend_ec2_instance.id 
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = module.backend_ec2_instance.private_ip
  }

   provisioner "file" {
    source      = "backend.sh"
    destination = "/tmp/backend.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/backend.sh",
      "sudo sh /tmp/backend.sh ${var.backend_tags.Resource} ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "backend" {
  instance_id = module.backend_ec2_instance.id
  state       = "stopped"
  depends_on = [null_resource.backend]
}

resource "aws_ami_from_instance" "backend" {
  name               = "${local.instance_name}-backend"
  source_instance_id = module.backend_ec2_instance.id
  depends_on = [aws_ec2_instance_state.backend]
  tags = merge(
        var.common_tags,
        var.backend_tags,
        {
            Name = "${local.instance_name}-backend"
        }
    )
}

resource "null_resource" "backend_delete" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.backend_ec2_instance.id 
  }

  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "aws ec2 terminate-instances --instance-ids ${module.backend_ec2_instance.id} --region us-east-1"
  }
  depends_on = [aws_ami_from_instance.backend]
}

resource "aws_lb_target_group" "backend" {
  name     = "${local.instance_name}-backend"
  target_type = "instance"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  health_check  {
    healthy_threshold = 3
    unhealthy_threshold = 2
    path = "/health"
    timeout = 4
    interval = 5
    matcher = "200-299"
    port = 8080
    protocol = "HTTP"
  }
  tags = merge(
        var.common_tags,
        var.target_group_tags,
        {
            Name = "${local.instance_name}-backend"
        }
    )
}

resource "aws_launch_template" "backend" {
  name = "${local.instance_name}-backend"
  update_default_version = true
  image_id = aws_ami_from_instance.backend.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  instance_initiated_shutdown_behavior = "terminate"
  tag_specifications {
    resource_type = "instance"

    tags = merge(
        var.common_tags,
        var.launch_template_tags,
        {
            Name = "${local.instance_name}-backend"
        }
    )
  }
}

resource "aws_autoscaling_group" "backend" {
  name                      = "${local.instance_name}-backend"
  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [local.private_subnet_id]
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  max_size                  = 10
  min_size                  = 2
  #force_delete              = true

# If the instances are not healthy with in 15m, autoscaling will delete that instance
  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "${local.instance_name}-backend"
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
  autoscaling_group_name = aws_autoscaling_group.backend.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

