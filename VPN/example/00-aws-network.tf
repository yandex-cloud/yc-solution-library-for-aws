resource "aws_vpc" "aws_demo_network" {
  cidr_block = var.aws_subnet_range

  tags = {
    Name = "yandex-vpc-demo"
  }
}


resource "aws_subnet" "aws_demo_subnet" {
  vpc_id     = aws_vpc.aws_demo_network.id
  cidr_block = var.aws_subnet_range

  tags = {
    Name = "yandex-vpc-demo"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.aws_demo_network.id

  tags = {
    Name = "yandex-vpc-demo"
  }
}

resource "aws_route_table" "gw" {
  vpc_id = aws_vpc.aws_demo_network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "yandex-vpc-demo"
  }
}
resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.aws_demo_network.id
  route_table_id = aws_route_table.gw.id
}


resource "aws_security_group" "vpn_sg" {
  vpc_id = aws_vpc.aws_demo_network.id

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {

    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "yandex-vpc-demo"
  }
}