data "aws_ami" "ami" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name = "name"
    c
  }
}

variable "lifecycles" {
  default = "t2.micro"
}

