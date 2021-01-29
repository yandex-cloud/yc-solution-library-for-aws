terraform {
  required_version = ">= 0.12.6"


  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.45"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.10"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
