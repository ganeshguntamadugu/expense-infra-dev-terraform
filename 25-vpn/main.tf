resource "aws_key_pair" "openvpn" {
  key_name   = "open-vpn"
  public_key = file("~/devops/openvpn.pub")
}

module "vpn_ec2_instance" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.OpenVPN.id
    name = "${local.instance_name}-vpn"
    key_name = aws_key_pair.openvpn.key_name
    instance_type = "t3.micro"

    create_security_group = false
    
    vpc_security_group_ids = [local.vpn_sg_id]
    subnet_id     = local.public_subnet_id

    tags = merge(
        var.common_tags,
        var.vpn_tags,
        {
            Name = "${local.instance_name}-vpn"
        }
    )
}