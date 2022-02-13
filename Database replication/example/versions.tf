terraform {
  required_version = ">= 1.1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.70"
    }
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.70"
    }
  }
}
