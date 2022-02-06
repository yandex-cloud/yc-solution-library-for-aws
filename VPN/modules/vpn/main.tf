terraform {
  required_version = ">= 1.1.5"


  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.70"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
