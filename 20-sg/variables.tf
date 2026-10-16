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

variable "mysql_sg_tags" {
    default = {
        Resource = "Security Group"
        Component = "MySQL"
    }
}

variable "backend_sg_tags" {
    default = {
        Resource = "Security Group"
        Component = "Backend"
    }
}

variable "app_alb_sg_tags" {
    default = {
        Resource = "Security Group"
        Component = "Backend-ALB"
    }
}

variable "frontend_sg_tags" {
    default = {
        Resource = "Security Group"
        Component = "Frontend"
    }
}

variable "web_alb_sg_tags" {
    default = {
        Resource = "Security Group"
        Component = "Frontend-ALB"
    }
}

variable "bastion_sg_tags" {
    default = {
        Resource = "Security Group"
        Component = "Bastion"
    }
}

variable "ansible_sg_tags" {
    default = {
        Resource = "Security Group"
        Component = "Ansible"
    }
}

variable "vpn_sg_tags" {
    default = {
        Resource = "Security Group"
        Component = "VPN"
    }
}

variable "parameter_tags" {
    default = {
        Resource = "SSM-Parameter-Store"
    }
}




