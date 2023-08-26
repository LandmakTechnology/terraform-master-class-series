# Resource: EC2 Instance
resource "aws_instance" "myec2" {
  ami           = data.aws_ami.amzLinux2.id
  instance_type = "t2.micro"
  user_data     = file("${path.module}/app1-install.sh")
  tags = {
    "Name" = "EC2 Demo"
  }
}
