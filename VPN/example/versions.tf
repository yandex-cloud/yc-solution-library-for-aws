provider "yandex" {

}


provider "aws" {
  profile = "default"
  region  = "us-west-2"
  version = "~> 3.10"
}


terraform {
  required_version = ">= 0.13"

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
