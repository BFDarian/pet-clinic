provider "aws" {
  region = "eu-west-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

# provider "kubernetes" {  
#   host = data.aws_eks_cluster.cluster.endpoint  
#   token = data.aws_eks_cluster_auth.cluster.token  
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
# }

module "VPC" {
  source = "./VPC"

  vpc_cidr = "10.0.0.0/16"
  nat_gate = module.Subnets.nat_gate
}

module "Subnets" {
  source = "./Subnets"

  vpc_id             = module.VPC.vpc_id
  subnet_cidr        = "10.0.1.0/24"
  availability_zone  = "eu-west-1a"
  route_table_id     = module.VPC.route_table_id
  pri_route_table_id = module.VPC.pri_route_table_id
  internet_gate      = module.VPC.internet_gate
  av_zone_pri1       = "eu-west-1b"
  av_zone_pri2       = "eu-west-1c"
  cidr_pri1          = "10.0.2.0/24"
  cidr_pri2          = "10.0.3.0/24"
  cidr_eks1          = "10.0.4.0/24"
  cidr_eks2          = "10.0.5.0/24"
  cidr_eks3          = "10.0.6.0/24"
  eks_azs1           = "eu-west-1a"
  eks_azs2           = "eu-west-1b"
  eks_azs3           = "eu-west-1c"
}

module "EC2" {
  source = "./EC2"

  instance_type          = "t2.medium"
  ami                    = "ami-0a8e758f5e873d1c1"
  key_name               = "id_rsa"
  availability_zone      = "eu-west-1a"
  subnet_id_pub          = module.Subnets.subnet_id_pub
  security_group         = module.Subnets.security_group
  instance_private_ip    = format("%s%s", substr(module.Subnets.subnet_cidr, 0, 7), "50") 
  db_password            = var.db_password
  private_security_group = module.Subnets.private_security_group
  subnet_group_name      = module.Subnets.subnet_group_name
  db_instance_class      = "db.t3.micro"
  initial_db_name        = "petClinic"
  
}

# module "EKS" {
#   source = "./EKS"


#   subnet_id_eks_pub_1 = module.Subnets.subnet_id_eks1
#   subnet_id_eks_pub_2 = module.Subnets.subnet_id_eks2
#   subnet_id_eks_pub_3 = module.Subnets.subnet_id_eks3

#   instance_type  = "t2.small"
#   vpc_id = module.VPC.vpc_id
#   security_group = aws_security_group.worker_group_mgmt_one.id
  

# }

# data "aws_eks_cluster" "cluster" {
#   name = module.EKS.cluster_id
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.EKS.cluster_id
# }

# resource "aws_security_group" "worker_group_mgmt_one" {
#   name_prefix = "worker_group_mgmt_one"
#   vpc_id      = module.VPC.vpc_id

#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"

#     cidr_blocks = [
#       "10.0.0.0/8",
#     ]
#   }
# }