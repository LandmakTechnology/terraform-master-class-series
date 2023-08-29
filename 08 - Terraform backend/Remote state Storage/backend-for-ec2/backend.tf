terraform {
  required_version = "~> 1.2" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }


  backend "s3" {
    bucket = "my-terraformstate-landmark-buc"
    key    = "terraform/terraform.tfstate"
    #dynamodb_table = "terraform-lock"
    region = "us-west-2"

  }
}

# Provider Block
provider "aws" {
  region = "us-west-2"
}
