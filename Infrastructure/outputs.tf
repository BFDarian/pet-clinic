output "instance_ip" {
  value = module.EC2.instance_public_IP
}

output "DB_Public_IP" {
  description = "RDS Instance Public IP"
  value       = module.EC2.db_endpoint
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.EKS.endpoint
}