variable "public_key_path" {
  description = "Path to public key file"
  default = "~/.ssh/id_rsa.pub"
}


variable "zone" {
  description = "Yandex Cloud default Zone for provisoned resources"
  default     = "ru-central1-a"
}

variable "yc_image_family" {
  description = "family"
  default     = "rhel"
}


variable "yandex_subnet_range" {
  description = "family"
  default     = "10.10.0.0/24"
}


variable "aws_subnet_range" {
  description = "family"
  default     = "10.250.0.0/24"
}


