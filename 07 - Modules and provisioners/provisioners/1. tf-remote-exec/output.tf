output "sql_username" {
  value = aws_db_instance.test-db.username
}

output "sql_password" {
  value = aws_db_instance.test-db.password
}

output "ssh_key" {
  value     = aws_key_pair.ssh.public_key
  sensitive = true
}

terraform {
  backend "s3" {
    dynamodb_table = ""
    key            = "remotestate"
    bucket         = ""
    region         = ""
  }
}