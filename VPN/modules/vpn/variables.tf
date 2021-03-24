variable "public_key_path" {
  description = "Path to public key file"
  default     = "~/.ssh/id_rsa.pub"
}


variable "zone" {
  description = "Yandex Cloud default Zone for provisoned resources"
  default     = "ru-central1-a"
}


variable "yandex_vpc_id" {
  description = "ID of the Yandex VPC where VPN instance will be created"
}

variable "aws_vpc_id" {
  description = "ID of the AWS VPC where VPN gateway will be attached"
}

variable "aws_route_table_id" {
  description = "ID of the AWS RT where VPN routes will be propagated"
}


variable "yandex_subnet_range" {
  description = "family"
  default     = "10.10.0.0/24"
}


variable "aws_subnet_range" {
  description = "family"
  default     = "10.250.0.0/24"
}
