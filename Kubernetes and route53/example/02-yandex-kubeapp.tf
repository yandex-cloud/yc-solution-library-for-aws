
provider "kubernetes" {
  load_config_file       = false
  alias                  = "yc_mk8s"
  host                   = yandex_kubernetes_cluster.multi_cloud_cluster.master.0.external_v4_endpoint
  cluster_ca_certificate = yandex_kubernetes_cluster.multi_cloud_cluster.master.0.cluster_ca_certificate
  token                  = data.yandex_client_config.client.iam_token

}


resource "kubernetes_pod" "mk8s_nginx" {
  depends_on = [yandex_kubernetes_node_group.multi_cloud_node_group]

  provider = kubernetes.yc_mk8s
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

resource "kubernetes_service" "mk8s_nginx" {
  provider = kubernetes.yc_mk8s

  metadata {
    name = "nginx-example"
  }
  spec {
    selector = {
      App = kubernetes_pod.mk8s_nginx.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "yc_lb_ip" {
  value = kubernetes_service.mk8s_nginx.load_balancer_ingress[0].ip
}

