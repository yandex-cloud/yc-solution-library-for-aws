



resource "yandex_vpc_address" "vpn_address" {
  name = "vpn-address"

  external_ipv4_address {
    zone_id = var.zone
  }
}



resource "yandex_vpc_subnet" "yandex_vpc_demo_subnet" {
  name           = "${var.yandex_vpc_id}-vpn-subnet"
  zone           = var.zone
  network_id     = var.yandex_vpc_id
  v4_cidr_blocks = [var.yandex_subnet_range]
  route_table_id = yandex_vpc_route_table.yandex_vpc_demo_rt.id
}

resource "yandex_vpc_route_table" "yandex_vpc_demo_rt" {
  name       = "aws-vpc-demo-rt"
  network_id = var.yandex_vpc_id

  static_route {
    destination_prefix = var.aws_subnet_range
    next_hop_address   = cidrhost(var.yandex_subnet_range, 10)
  }
}



resource "yandex_vpc_security_group" "vpn_vm_sg" {
  name       = "aws-vpc-demo-sg"
  network_id = var.yandex_vpc_id



  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 500
  }

  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 4500
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22

  }
  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535


  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}