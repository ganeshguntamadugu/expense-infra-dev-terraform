module "vpc" {
  source = "../../terraform-aws-vpc"
  # source = "git::https://github.com/ganeshguntamadugu/terraform-aws-vpc.git?ref=main"
  vpc_cidr = var.vpc_cidr
  project_name = var.project_name
  environment = var.environment
  common_tags = var.common_tags
  vpc_tags = var.vpc_tags
  igw_tag = var.igw_tag
  public_subnet_tags = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
  database_subnet_tags = var.database_subnet_tags
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  db_subnet_group_tags = var.db_subnet_group_tags
  nat_gateway_tags = var.nat_gateway_tags
  public_route_table_tags = var.public_route_table_tags
  private_route_table_tags = var.private_route_table_tags
  database_route_table_tags = var.database_route_table_tags
  is_peering_required = var.is_peering_required
  vpc_peering_tags = var.peering_tags
}

