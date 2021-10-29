output "instance_ip" {
  value = module.EC2.instance_public_IP
}

output "DB_Public_IP" {
  description = "RDS Instance Public IP"
  value       = module.EC2.db_endpoint
}

