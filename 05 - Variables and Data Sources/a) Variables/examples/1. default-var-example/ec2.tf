#resource block
resource "aws_instance" "my_ec2" {
  ami           = var.my_ami
  instance_type = var.my_instance_type
  key_name      = var.my_key

  tags = {
    "Name" = "Ec2-Demo"
  }
}
