#resource block
resource "aws_instance" "my_ec2" {
  provider = aws.east
  #count = length(var.ec2_name)
  count = 2
  ami           = data.aws_ami.amzLinux2.id
  instance_type = var.my_instance_type
  key_name      = var.my_key

  tags = {
    #"Name" = var.ec2_name[count.index]
    Name = "Demo-ec2 ${count.index}"
  }
}
