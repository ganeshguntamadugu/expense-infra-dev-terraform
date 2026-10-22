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

variable "app_alb_tags" {
    default = {
        Resource = "Backend_ALB"
    }
}

variable "zone_name" {
    default = "gangs.shop"
}

variable "parameter_tags" {
    default = {
        Resource = "SSM-Parameter-Store"
    }
}




