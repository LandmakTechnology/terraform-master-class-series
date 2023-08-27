locals {
  ingress-config = [
    { descr = "Elasticsearch port", protocol = "tcp", from_port = 9200, to_port = 9200, cidr_blocks = ["10.0.0.0/16"] },
    { descr = "Logstash ports", protocol = "tcp", from_port = 5043, to_port = 5044, cidr_blocks = ["10.0.0.0/16"] },
    { descr = "Kibana port", protocol = "tcp", from_port = 5601, to_port = 5601, cidr_blocks = ["10.0.0.0/16"] },
    { descr = "Ssh port", protocol = "tcp", from_port = 22, to_port = 22, cidr_blocks = ["0.0.0.0/0"] },

  ]
}

resource "aws_security_group" "elk_sg" {
  name        = "elk_sg"
  description = "Allow all elasticsearch traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  dynamic "ingress" {
    for_each = local.ingress-config
    content {
      description = ingress.value.descr
      from_port   = ingress.value.from_port
      protocol    = ingress.value.protocol
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  # outbound
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
