module "vpn" {
  source = "../modules/vpn"

  yandex_vpc_id = yandex_vpc_network.yandex_vpc_demo_network.id
  aws_vpc_id = aws_vpc.aws_demo_network.id
  aws_route_table_id = aws_route_table.gw.id
  yandex_subnet_range = var.yandex_subnet_range
  aws_subnet_range = var.aws_subnet_range
}