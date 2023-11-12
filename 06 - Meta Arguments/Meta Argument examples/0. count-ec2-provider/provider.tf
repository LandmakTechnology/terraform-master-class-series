#terraform block
terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


#provider block
provider "aws" {
  region  = var.aws_region
}

provider "aws" {
  alias = "east"
  region = "us-east-1"
}
