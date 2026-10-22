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

variable "frontend_tags" {
    default = {
        Resource = "frontend"
    }
}

variable "target_group_tags" {
    default = {
        Resource = "Target Group"
    }
}


variable "launch_template_tags" {
    default = {
        Resource = "Launch Template"
    }
}

variable "zone_name" {
    default = "gangs.shop"
}



