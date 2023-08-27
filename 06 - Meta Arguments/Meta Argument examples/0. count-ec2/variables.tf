variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "my_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "my_key" {
  type    = string
  default = "Automationkey"
}

variable "ec2_name" {
  type    = list(string)
  default = ["dev", "staging", "prod"]
}
