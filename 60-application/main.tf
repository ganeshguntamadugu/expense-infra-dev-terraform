module "mysql_ec2_instance" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.expense.id
    name = "${local.instance_name}-mysql"

    instance_type = "t3.micro"

    create_security_group = false

    vpc_security_group_ids = [local.mysql_sg_id]
    subnet_id     = local.database_subnet_id

    tags = merge(
        var.common_tags,
        var.mysql_tags,
        {
            Name = "${local.instance_name}-mysql"
        }
    )
}


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

module "ansible_ec2_instance" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.expense.id
    name = "${local.instance_name}-ansible"

    instance_type = "t3.micro"

    create_security_group = false
    
    vpc_security_group_ids = [local.ansible_sg_id]
    subnet_id     = local.public_subnet_id

    user_data = file("expense.sh")

    tags = merge(
        var.common_tags,
        var.frontend_tags,
        {
            Name = "${local.instance_name}-ansible"
        }
    )
}

