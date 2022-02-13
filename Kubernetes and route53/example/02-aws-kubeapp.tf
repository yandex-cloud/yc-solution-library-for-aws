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
  #config_path            = "kubeconfig_${data.aws_eks_cluster.cluster.name}"
  #config_path            = "~/.kube/config"
  #config_context         = "aws_eks"
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
      image = "nginx:${var.nginx_version}"
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
  value = kubernetes_service.eks_nginx.status.0.load_balancer.0.ingress.0.hostname
}
