# Terraform Settings Block
terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 3.0"
        # Optional but recommended in production
    }
  }
}

# Provider Block
provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

# Resource Block

resource "aws_instance" "project2ec2" {
  ami = ""
  instance_type = "t2.micro"

  tags = {
    Name = "FirstEC2"
  }
}
