output "subnet_id_pub" {
  value = aws_subnet.pub.id
}
output "subnet_id_pri1" {
  value = aws_subnet.pri1.id
}
output "subnet_id_pri2" {
  value = aws_subnet.pri2.id
}
output "security_group" {
  value = aws_security_group.allow_ssh.id
}
output "subnet_cidr" {
  value = var.subnet_cidr
}
output "nat_gate" {
  value = aws_nat_gateway.private_nat
}
output "subnet_group_name" {
  value = aws_db_subnet_group.private.name
}
output "private_security_group" {
  value = aws_security_group.allow_sql.id
}