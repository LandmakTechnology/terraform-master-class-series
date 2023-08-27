resource "aws_instance" "my_elk_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = [for s in var.myinstance : lower(s)][1]
  subnet_id     = data.terraform_remote_state.network.outputs.public_subnets[0]
  key_name      = var.my_key

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true
  }

  vpc_security_group_ids = [
    aws_security_group.elk_sg.id,
  ]

  depends_on = [aws_security_group.elk_sg]

}

resource "aws_eip" "ip" {
  instance = aws_instance.my_elk_instance.id
}

