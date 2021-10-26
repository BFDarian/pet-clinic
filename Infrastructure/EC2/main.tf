resource "aws_instance" "host" {
  ami               = var.ami 
  instance_type     = var.instance_type
  key_name          = var.key_name
  availability_zone = var.availability_zone

  network_interface {
    network_interface_id = aws_network_interface.prod.id
    device_index         = 0
  }
}

resource "aws_network_interface" "prod" {
  subnet_id       = var.subnet_id_pub
  private_ips     = [var.instance_private_ip]
  security_groups = [var.security_group]
}

resource "aws_db_instance" "rds" {
  allocated_storage      = 10 # Gb
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.db_instance_class 
  name                   = var.initial_db_name
  username               = "root"
  password               = var.db_password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = var.subnet_group_name
  vpc_security_group_ids = [var.private_security_group]
  publicly_accessible    = false
}
