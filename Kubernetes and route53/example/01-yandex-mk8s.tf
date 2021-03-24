resource "yandex_iam_service_account" "k8s_sa" {
  name        = "k8s-ru-sa-demo-aws"
  folder_id   = data.yandex_client_config.client.folder_id
  description = "service account to manage VMs"
}


resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = data.yandex_client_config.client.folder_id

  role = "editor"

  member = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}

resource "yandex_kubernetes_cluster" "multi_cloud_cluster" {
  depends_on = [yandex_resourcemanager_folder_iam_member.editor]

  name = "k8s-ru-cluster01"

  network_id         = yandex_vpc_network.aws_k8s_vpc.id
  service_ipv4_range = var.k8s_service_ipv4_range
  cluster_ipv4_range = var.k8s_pod_ipv4_range

  master {
    version = var.k8s_version
    zonal {
      zone      = yandex_vpc_subnet.aws_k8s_subnet.zone
      subnet_id = yandex_vpc_subnet.aws_k8s_subnet.id
    }

    public_ip          = true
    security_group_ids = [yandex_vpc_security_group.sg_k8s.id, yandex_vpc_security_group.k8s_master_whitelist.id, yandex_vpc_security_group.k8s_public_services.id]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.k8s_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_sa.id

  labels = {
    country = "ru"
  }

  release_channel         = "REGULAR"
  network_policy_provider = "CALICO"


}

resource "yandex_kubernetes_node_group" "multi_cloud_node_group" {

  cluster_id  = yandex_kubernetes_cluster.multi_cloud_cluster.id
  name        = "k8s-ru-ng01"
  description = "description"
  version     = var.k8s_version

  labels = {
    country = "ru"
  }

  instance_template {
    platform_id = "standard-v2"
    network_interface {
      nat                = true
      security_group_ids = [yandex_vpc_security_group.sg_k8s.id, yandex_vpc_security_group.k8s_public_services.id]
      subnet_ids         = [yandex_vpc_subnet.aws_k8s_subnet.id]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}

### SG
resource "yandex_vpc_security_group" "sg_k8s" {
  name        = "sg-k8s"
  description = "apply this on both cluster and nodes, minimal security group which allows k8s cluster to work"
  network_id  = yandex_vpc_network.aws_k8s_vpc.id
  ingress {
    protocol       = "TCP"
    description    = "allows health_checks from load-balancer health check address range, needed for HA cluster to work as well as for load balancer services to work"
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "allows communication within security group, needed for master-to-node, and node-to-node communication"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "ANY"
    description    = "allows pod-pod and service-service communication, change subnets with your cluster and service CIDRs"
    v4_cidr_blocks = [var.k8s_pod_ipv4_range, var.k8s_service_ipv4_range]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol       = "TCP"
    description    = "allows ssh to nodes from private addresses"
    v4_cidr_blocks = [yandex_vpc_subnet.aws_k8s_subnet.v4_cidr_blocks[0]]
    port           = 22
  }
  ingress {
    protocol       = "ICMP"
    description    = "allows icmp from private subnets for troubleshooting"
    v4_cidr_blocks = [yandex_vpc_subnet.aws_k8s_subnet.v4_cidr_blocks[0]]
  }
  egress {
    protocol       = "ANY"
    description    = "we usually allow all the egress traffic so that nodes can go outside to s3, registry, dockerhub etc."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
resource "yandex_vpc_security_group" "k8s_public_services" {
  name        = "k8s-public-services"
  description = "apply this on nodes, security group that opens up inbound port ranges on nodes, so that your public-facing services can work"
  network_id  = yandex_vpc_network.aws_k8s_vpc.id
  ingress {
    protocol       = "TCP"
    description    = "allows inbound traffic from Internet on NodePort range, apply to nodes, no need to apply on master, change ports or add more rules if using custom ports"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
}
resource "yandex_vpc_security_group" "k8s_master_whitelist" {
  name        = "k8s-master-whitelist"
  description = "apply this on cluster, to define range of ip-addresses which can access cluster API with kubectl and such"
  network_id  = yandex_vpc_network.aws_k8s_vpc.id
  ingress {
    protocol       = "TCP"
    description    = "whitelist for kubernetes API, controls who can access cluster API from outside, replace with your management ip range"
    v4_cidr_blocks = var.k8s_whitelist
    port           = 6443
  }
  ingress {
    protocol       = "TCP"
    description    = "whitelist for kubernetes API, controls who can access cluster API from outside, replace with your management ip range"
    v4_cidr_blocks = var.k8s_whitelist
    port           = 443
  }
}
