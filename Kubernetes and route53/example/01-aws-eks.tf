

locals {
  cluster_name = "test-eks-${random_string.suffix.result}"
}


module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "13.2.1"
  cluster_name    = local.cluster_name
  cluster_version = var.k8s_version
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  worker_groups = [
    {
      instance_type = "t2.medium"
      asg_max_size  = 2
    }
  ]
}


output "eks_cluster_name" {
  value = data.aws_eks_cluster.cluster.name
}
