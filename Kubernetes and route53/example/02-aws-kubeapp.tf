data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  alias                  = "aws_eks"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = true
  config_path = "kubeconfig_${data.aws_eks_cluster.cluster.name}"
}

resource "kubernetes_pod" "eks_nginx" {
  provider = kubernetes.aws_eks
  metadata {
    name = "nginx-example"
    labels = {
      App = "nginx"
    }
  }

  spec {
    container {
      image = "nginx:1.7.8"
      name  = "example"

      port {
        container_port = 80
      }
    }
  }
}

resource "kubernetes_service" "eks_nginx" {
  provider = kubernetes.aws_eks

  metadata {
    name = "nginx-example"
  }
  spec {
    selector = {
      App = kubernetes_pod.eks_nginx.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "eks_lb_ip" {
  value = kubernetes_service.eks_nginx.load_balancer_ingress[0].hostname
}

