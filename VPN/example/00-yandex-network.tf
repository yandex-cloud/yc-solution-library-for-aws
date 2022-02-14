#network

resource "yandex_vpc_network" "yandex_vpc_demo_network" {
  name = "aws-vpc-demo-network"
}

# public-subnet

resource "yandex_vpc_security_group" "user_vm_sg" {
  name       = "aws-vpc-demo-user-sg"
  network_id = yandex_vpc_network.yandex_vpc_demo_network.id


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