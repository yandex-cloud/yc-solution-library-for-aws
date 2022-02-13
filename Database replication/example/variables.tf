variable "db_name" {
  description = "Database that will be created on both sides"
  default     = "demo_db"
}

variable "db_user" {
  description = "Database owner that will be created on both sides"
  default     = "demo_user"
}

variable "db_password" {
  sensitive   = true
  description = "Database password for owner user that will be created on both sides"
  default = "suP87-dbPw"
}

variable "identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  default = "demodb-postgres"
}

variable "db_port" {
  description = "DB Instance TCP port"
  default = "6432"
}

variable "dt_enable" {
  description = "Yandex Data Transfer Enable flag"
  default = false
}
