data "aws_ami" "ami" {
  owners = ["amazon"]
  most_recent = true
}

variable "lifecycles" {
  default = "t2.micro"
}

