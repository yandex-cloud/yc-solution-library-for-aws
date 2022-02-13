
locals {
  cluster_name = "test-eks-${random_string.suffix.result}"
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "18.4.0"

  cluster_name = local.cluster_name
  cluster_version = var.k8s_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    green = {
      min_size = 1
      max_size = 10
      desired_size = 1

      instance_types = ["t3.large"]
    }
  }
}


output "eks_cluster_name" {
  value = data.aws_eks_cluster.cluster.name
}
