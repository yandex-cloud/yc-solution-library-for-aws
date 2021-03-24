### Datasource
data "yandex_client_config" "client" {}

#network

resource "yandex_vpc_network" "aws_k8s_vpc" {
  name      = "yc-subnet"
  folder_id = data.yandex_client_config.client.folder_id
}

# public-subnet

resource "yandex_vpc_subnet" "aws_k8s_subnet" {
  name           = "yc-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.aws_k8s_vpc.id
  v4_cidr_blocks = [var.yandex_subnet_range]
}

