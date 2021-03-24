data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


data "template_file" "aws_vm_cloud_init" {
  template = file("metadata/aws-vm.tpl.yaml")
  vars = {

    ssh_key = file(var.public_key_path)

  }
}


resource "aws_instance" "user_vm" {
  ami = data.aws_ami.ubuntu.id

  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.aws_demo_subnet.id
  vpc_security_group_ids      = [aws_security_group.vpn_sg.id]
  associate_public_ip_address = true
  user_data                   = data.template_file.aws_vm_cloud_init.rendered

  tags = {
    Name = "yandex-vpc-demo"
  }
}


output "aws_vm_external_ip_address" {
  value = aws_instance.user_vm.public_ip
}


output "aws_vm_internal_ip_address" {
  value = aws_instance.user_vm.private_ip
}