# Resource: EC2 Instance
resource "aws_instance" "myec2" {
  ami = var.my_ami
  instance_type = var.instance_type

  tags = {
    "Name" = var.instance_name
  }
}

variable "my_ami" {
  type = string
  default = "ami-0e5b6b6a9f3db6db8"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "instance_name" {
  type = string
  default = "FirstEC2"
}