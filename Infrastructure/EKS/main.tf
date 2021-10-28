# module "eks" {
#   source          = "terraform-aws-modules/eks/aws"
#   cluster_name    = "cluster"
#   cluster_version = "1.21"
#   subnets         = [var.subnet_id_eks_pub_1,var.subnet_id_eks_pub_2,var.subnet_id_eks_pub_3]

#   tags = {
#     Environment = "production"
#   }

#   vpc_id = var.vpc_id

#   workers_group_defaults = {
#     root_volume_type = "gp2"
#   }

#   worker_groups = [
#     {
#       name                          = "worker-group-1"
#       instance_type                 = "t2.small"
#       asg_desired_capacity          = 2
#       additional_security_group_ids = [var.security_group]
#       public_ip                     = true
#     }, 
#   ]
# }