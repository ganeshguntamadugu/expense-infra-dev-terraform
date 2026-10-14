variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}


variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
    }
}

variable "mysql_tags" {
    default = {
        Resource = "MySQL Instance"
    }
}

variable "backend_tags" {
    default = {
        Resource = "Backend Instance"
    }
}

variable "frontend_tags" {
    default = {
        Resource = "Frontend Instance"
    }
}

variable "zone_name" {
    default = "gangs.shop"
}


