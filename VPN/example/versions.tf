
provider "aws" {
  profile                 = "default"
  region                  = var.region
  shared_credentials_file = "$HOME/.aws/credentials"
}


terraform {
  required_version = ">= 0.13"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.5"
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
