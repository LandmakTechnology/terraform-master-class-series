# Create a Null Resource and Provisioners
resource "null_resource" "my_null_resource" {
  depends_on = [time_sleep.wait_for_instance]
  # Connection Block for Provisioners to connect to the EC2 Instance

  connection {
    host        = aws_eip.ip.public_ip
    type        = "ssh"
    user        = var.instance_user
    private_key = file("${path.module}/mykey/elk-instance.pem")
  }

  provisioner "file" {
    source      = "scripts/elasticsearch.yml"
    destination = "/tmp/elasticsearch.yml"
  }

  provisioner "file" {
    source      = "scripts/kibana.yml"
    destination = "/tmp/kibana.yml"
  }

  provisioner "file" {
    source      = "scripts/apache-01.conf"
    destination = "/tmp/apache-01.conf"
  }

  provisioner "file" {
    source      = "scripts/installELK.sh"
    destination = "/tmp/installELK.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x    /tmp/installELK.sh",
      "sudo sed -i -e 's/\r$//' /tmp/installELK.sh", # Remove the spurious CR characters.
      "sudo /tmp/installELK.sh",
    ]
  }
}
