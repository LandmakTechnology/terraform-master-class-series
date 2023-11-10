# Terraform 10 high level blocks
In Terraform, a block is a fundamental unit used to define and configure
different aspects of your infrastructure.

## Block-1: **Terraform Settings Block**
This is used to configure some behaviours of Terraform itself,
such as requiring a minimum Terraform version to apply your configuration.
```
terraform {
  required_version = "~> 1.0" #1.1.4/5/6/7   1.2/3/4/5 1.1.4/5/6/7
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
```


## Block-2: **Provider Block**
A Provider in Terraform is a plugin that enables interaction with an API.
Provider Block configuration allows Terraform to interact with cloud providers, SaaS providers,
and other APIs.
Some providers require you to configure them with endpoint URLs, cloud regions, or other
settings before Terraform can use them.
Additionally, all Terraform configurations MUST declare which providers they require
so that Terraform can install and use them.
```
provider "aws" {
  profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = "us-west-2"
}
```

## Block-3: **Resource Block**
A Resource Block declares a resource of a given type ("aws_instance") with a given local name ("web").
The name is used to refer to this resource from elsewhere in the same Terraform module,
but has no significance outside that module's scope. This block is used to build resources.
```
resource "aws_instance" "inst1" {
  ami           = "ami-0e5b6b6a9f3db6db8" # Amazon Linux
  instance_type = var.instance_type
}
```

## Block-4: **Input Variables Block**
Terraform Input Variables are used as parameters to input values at run time to customize our
deployments. Input terraform variables can be defined in the main.tf configuration file but it
is a best practice to define them ins a separate variable.tf file to provide better readability
and organization.
```
variable "instance_type" {
  default     = "t2.micro"
  description = "EC2 Instance Type"
  type        = string
}
```

## Block-5: **Output Values Block**
Terraform Output Values let you export structured data about your resources. If we want to get an attribute 
out of our resource after creation, we have to use this block at run time.
You can use this data to configure other parts or your infrastructure with automation tools,
or as a data source for another Terraform workspace. Outputs are how you expose data
from a child module to a root module.
```
output "ec2_instance_publicip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.inst1.public_ip
}
```

## Block-6: **Local Values Block**
A Locals block is used to define local variables within a module.
A Local Value assigns a name to a Terraform expression, allowing it to be used multiple times
within a module without repeating the expression.
It mainly serves the purpose of reducing duplication within the Terraform code.
 - An example to have is a bucket name that is a concatenation of an app name and environment name.
```
locals {
  name = "${var.app_name}-${var.environment_name}"
}

bucket_name = local.name
```

## Block-7: **Data sources Block**
Data blocks are used to define and configure Data Sources.
Data Sources are used to fetch data from a remote system and use it in your infrastructure.
E.g. A data source can be used to get a list of IP address tha a cloud provider exposes.
 - This example is used to get the latest AMI ID for Amazon Linux2 OS
```
data "aws_ami" "amzLinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
```

## Block-8: **Modules Block**
A Terraform Module is a collection of standard configuration files in a dedicated directory.
Terraform modules encapsulate groups of resources dedicated to one task, reducing the
amount of code you have to develop for similar infrastructure components.
- An example of an AWS EC2 Instance Module from the terraform registry.
```
module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "my-modules-demo"
  instance_count         = 2
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = "t2.micro"
  key_name               = "terraform-key"
  monitoring             = true
  vpc_security_group_ids = ["sg-08b25c5a5bf489ffa"] # Get Default VPC Security Group ID and replace
  subnet_id              = "subnet-4ee95470"        # Get one public subnet id from default vpc and replace
  user_data              = file("apache-install.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Block-9: **Moved Blocks**
A Moved Block is a configuration block that tracks resource moves.
It allows you to instruct Terraform that a resource or data source has a new ID.
```
moved {
  from = "aws_instance.my_ec2"
  to   = "aws_instance.my_new_ec2"
}
```

## Block-10: **Import Blocks**
The Import Block is a feature that allows users to import existing infrastructure
resources into Terraform, bringing them under Terraform's management.
This feature was introduced in Terraform v1.5.0.
```
import {
  to = aws_vpc.my_vpc
  id = "vpc-0b37c8c1dd6d9c791"
}

resource "aws_vpc" "my_vpc" {}
```
