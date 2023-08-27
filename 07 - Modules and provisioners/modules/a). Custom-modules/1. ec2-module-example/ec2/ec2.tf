
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amzLinux2.id
  instance_type = var.instance_type

  tags = {
    Name = var.ec2name
  }
}


