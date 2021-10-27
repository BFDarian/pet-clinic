resource "aws_subnet" "pub" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "Pub"
  }
}

resource "aws_subnet" "pri1" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_pri1
  availability_zone = var.av_zone_pri1

  tags = {
    Name = "Private"
  }
}

resource "aws_subnet" "pri2" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_pri2
  availability_zone = var.av_zone_pri2 

  tags = {
    Name = "Private"
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "rds"
  subnet_ids = [aws_subnet.pri1.id, aws_subnet.pri2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_nat_gateway" "private_nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.pub.id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [var.internet_gate]
}

resource "aws_eip" "nat_ip" {
  vpc              = true
  depends_on       = [var.internet_gate]
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub.id
  route_table_id = var.route_table_id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.pri1.id
  route_table_id = var.pri_route_table_id
}
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.pri2.id
  route_table_id = var.pri_route_table_id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
      description      = "SSH access"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
      description      = "frontend"
      from_port        = 8081
      to_port          = 8081
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  ingress {
      description      = "jenkins"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
      description      = "backend"
      from_port        = 9966
      to_port          = 9966
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
      description      = "http"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_sql" {
  name        = "allow_sql"
  description = "Allow SQL inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
      description      = "SQL access"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "allow_sql"
  }
}