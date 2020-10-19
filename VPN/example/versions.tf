provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  version = "~> 0.45"
}


provider "aws" {
  profile = "default"
  region  = "us-west-2"
  version = "~> 3.10"
}


terraform {
  required_version = ">= 0.12.6"

  required_providers {
    yandex = "~> 0.45"
    aws = "~> 3.10"
  }
}
