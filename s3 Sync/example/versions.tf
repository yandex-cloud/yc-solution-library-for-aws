

provider "aws" {
  profile = "default"
  region  = "us-west-1"

}


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
    archive = {
      source = "hashicorp/archive"
    }
    local = {
      source = "hashicorp/local"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
