terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "gangs-remote-state"
    key = "expense-dev-vpc" #Key should not be same for each file
    region = "us-east-1"
    #dynamodb_table = "gangs_locking"
    use_lockfile = true
  }
  
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

