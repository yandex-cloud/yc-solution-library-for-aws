variable "public_key_path" {
  description = "Path to public key file"
  default     = "~/.ssh/id_rsa.pub"
}

variable "zone" {
  description = "Yandex Cloud default Zone for provisoned resources"
  default     = "ru-central1-a"
}

variable "yandex_subnet_range" {
  description = "family"
  default     = "10.10.0.0/24"
}

variable "k8s_version" {
  description = "EKS and Mk8s kubernetes version"
  default     = "1.21"
}

variable "nginx_version" {
  description = "Nginx version"
  default     = "1.21.6"
}

variable "region" {
  default = "us-west-1"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "777777777777",
    "888888888888",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}

variable "k8s_service_ipv4_range" {
  type        = string
  default     = "10.150.0.0/16"
  description = "CIDR for k8s services"
}

variable "k8s_pod_ipv4_range" {
  type        = string
  default     = "10.140.0.0/16"
  description = "CIDR for pods in k8s cluster"
}

variable "k8s_whitelist" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "Range of ip-addresses which can access cluster API with kubectl etc"
}

variable "aws_domain_name" {
  type        = string
  default     = "aws-yandex-example.com"
  description = "Domain name for AWS Route53"
}
