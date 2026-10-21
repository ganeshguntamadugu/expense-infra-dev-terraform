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

variable "backend_tags" {
    default = {
        Resource = "backend"
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



