
data "yandex_vpc_address" "vpn_address" {
  address_id = yandex_vpc_address.vpn_address.id
}


resource "yandex_compute_image" "vpn_instance" {
  source_family = "ipsec-instance-ubuntu"
}

data "template_file" "vpn_cloud_init" {
  template = file("${path.module}/metadata/vpn.tpl.yaml")
  vars = {
    ssh_key     = file(var.public_key_path)
    left_id     = data.yandex_vpc_address.vpn_address.external_ipv4_address.0.address
    right       = aws_vpn_connection.yandex_vpn_connection.tunnel1_address
    leftsubnet  = var.yandex_subnet_range
    rightsubnet = var.aws_subnet_range
    psk         = aws_vpn_connection.yandex_vpn_connection.tunnel1_preshared_key
  }
}

resource "yandex_compute_instance" "vpn_vm" {
  name        = "vpn-vm"
  hostname    = "vpn-vm"
  description = "vpn-vm"
  zone        = var.zone
  platform_id = "standard-v2"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = "100"
  }
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.vpn_instance.id
      type     = "network-ssd"
      size     = 33
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.yandex_vpc_demo_subnet.id
    ip_address         = cidrhost(var.yandex_subnet_range, 10)
    nat                = true
    nat_ip_address     = data.yandex_vpc_address.vpn_address.external_ipv4_address.0.address
    security_group_ids = [yandex_vpc_security_group.vpn_vm_sg.id]
  }

  metadata = {
    user-data = data.template_file.vpn_cloud_init.rendered
  }

}


