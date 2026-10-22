module "bastion_ec2_instance" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.expense.id
    name = "${local.instance_name}-bastion"

    instance_type = "t3.micro"

    create_security_group = false
    
    vpc_security_group_ids = [local.bastion_sg_id]
    subnet_id     = local.public_subnet_id

    tags = merge(
        var.common_tags,
        var.bastion_tags,
        {
            Name = "${local.instance_name}-bastion"
        }
    )
}