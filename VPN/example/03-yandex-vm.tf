
data "yandex_compute_image" "vm_instance" {
  family = "ubuntu-2004-lts"
}


data "template_file" "yc_vm_cloud_init" {
  template = file("metadata/vm.tpl.yaml")
  vars = {

    ssh_key = file(var.public_key_path)

  }
}


resource "yandex_compute_instance" "user_vm" {
  name        = "aws-demo-vm"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_instance.id
    }
  }

  network_interface {
    subnet_id          = module.vpn.yandex_subnet_id
    ip_address         = cidrhost(var.yandex_subnet_range, 5)
    security_group_ids = [yandex_vpc_security_group.user_vm_sg.id]
    nat                = true
  }

  metadata = {
    user-data = data.template_file.yc_vm_cloud_init.rendered
  }

}

output "yandex_vm_external_ip_address" {
  value = yandex_compute_instance.user_vm.network_interface.0.nat_ip_address
}

output "yandex_vm_internal_ip_address" {
  value = yandex_compute_instance.user_vm.network_interface.0.ip_address
}