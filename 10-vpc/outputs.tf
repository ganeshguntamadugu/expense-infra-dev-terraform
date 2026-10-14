output "vpc_ids" {
  value = module.vpc.vpc_id
}

output "igww_id" {
  value = module.vpc.igw_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

# output "az_checks" {
#   value = module.vpc.az_check 
# }

# output "filtering_vpcc" {
#     value = module.vpc.filtering_vpc_info
# }

# output "route_table_id" {
#     value = module.vpc.route_table_id 
# }