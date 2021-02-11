resource "yandex_iam_service_account" "k8s_sa" {
  name        = "k8s-ru-sa"
  description = "service account to manage VMs"
}


data "yandex_resourcemanager_folder" "default" {
  name     = "nrk-dev"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = "${data.yandex_resourcemanager_folder.default.id}"

  role = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s_sa.id}",
  ]
}

resource "yandex_kubernetes_cluster" "multi_cloud_cluster" {
  depends_on = [yandex_resourcemanager_folder_iam_binding.editor]

  name        = "k8s-ru-cluster01"

  network_id = "${yandex_vpc_network.aws_k8s_vpc.id}"

  master {
    version = var.k8s_version
    zonal {
      zone      = "${yandex_vpc_subnet.aws_k8s_subnet.zone}"
      subnet_id = "${yandex_vpc_subnet.aws_k8s_subnet.id}"
    }

    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = "${yandex_iam_service_account.k8s_sa.id}"
  node_service_account_id = "${yandex_iam_service_account.k8s_sa.id}"

  labels = {
    country       = "ru"
  }

  release_channel = "REGULAR"
  network_policy_provider = "CALICO"


}

resource "yandex_kubernetes_node_group" "multi_cloud_node_group" {
  
  cluster_id  = "${yandex_kubernetes_cluster.multi_cloud_cluster.id}"
  name        = "k8s-ru-ng01"
  description = "description"
  version     = var.k8s_version

  labels = {
    country       = "ru"
  }

  instance_template {
    platform_id = "standard-v2"
    nat         = true

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
