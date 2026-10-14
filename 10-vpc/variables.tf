variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "public_subnet_cidrs" {
    default = ["10.0.1.0/24", "10.0.2.0/24"]
  
}

variable "private_subnet_cidrs" {
    default = ["10.0.11.0/24", "10.0.12.0/24"]
  
}

variable "database_subnet_cidrs" {
    default = ["10.0.21.0/24", "10.0.22.0/24"]
  
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
    }
}

variable "vpc_tags" {
    default = {
        Resource = "VPC"
    }
}

variable "igw_tag" {
   default = {
        Resource = "Internet Gateway"
   }
}

variable "public_subnet_tags" {
    default = {
        Resource = "Public Subnet"
   }
}

variable "private_subnet_tags" {
    default = {
        Resource = "Private Subnet"
   }
}

variable "database_subnet_tags" {
    default = {
        Resource = "Database Subnet"
   }
}

variable "db_subnet_group_tags" {
    default = {
        Resource = "Database Subnet Group"
    }
}

variable "nat_gateway_tags" {
    default = {
        Resource = "Nat Gateway"
    }
  
}

variable "public_route_table_tags" {
    default = {
        Resource = "Public-route-table"
    }
}

variable "private_route_table_tags" {
    default = {
        Resource = "Private-route-table"
    }
}

variable "database_route_table_tags" {
    default = {
        Resource = "Database-route-table"
    }
}

#Peering
variable "is_peering_required" {
    default = true
}

variable "peering_tags" {
    default = {
        Resource = "Peering-connections"
    }
}

variable "parameter_tags" {
    default = {
        Resource = "SSM-Parameter-Store"
    }
}
