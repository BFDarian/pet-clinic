output "instance_public_IP" {
  value = aws_instance.host.public_ip
}

output "db_endpoint" {
  value = aws_db_instance.rds.endpoint
}