terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.49"
    }
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
