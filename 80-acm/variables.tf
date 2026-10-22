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

variable "acm_tags" {
    default = {
        Resource = "ACM"
    }
}

variable "parameter_tags" {
    default = {
        Resource = "SSM-Parameter-Store"
    }
}


variable "zone_name" {
    default = "gangs.shop"
}



