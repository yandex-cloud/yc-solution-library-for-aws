resource "aws_vpn_gateway" "yandex_vpn_gateway" {
  vpc_id = var.aws_vpc_id


  tags = {
    Name = "yandex-vpn-demo"
  }
}

resource "aws_customer_gateway" "yandex_customer_gateway" {
  bgp_asn    = 65000
  ip_address = data.yandex_vpc_address.vpn_address.external_ipv4_address.0.address # see 01-yandex-vpn.tf
  type       = "ipsec.1"

  tags = {
    Name = "yandex-vpn-demo"
  }
}

resource "aws_vpn_connection" "yandex_vpn_connection" {
  vpn_gateway_id      = aws_vpn_gateway.yandex_vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.yandex_customer_gateway.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name = "yandex-vpn-demo"
  }
}

resource "aws_vpn_connection_route" "yandex_vpn_connection" {
  destination_cidr_block = var.yandex_subnet_range
  vpn_connection_id      = aws_vpn_connection.yandex_vpn_connection.id
}

resource "aws_vpn_gateway_route_propagation" "example" {
  vpn_gateway_id = aws_vpn_gateway.yandex_vpn_gateway.id
  route_table_id = var.aws_route_table_id
}

