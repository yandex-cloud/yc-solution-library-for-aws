variable db_name {
    description = "Database that will be created on both sides"
    default = "demo_db"
}

variable db_user {
    description = "Database owner that will be created on both sides"
    default = "demo_user"
}

variable db_password {
    sensitive   = true
    description = "Database password for owner user that will be created on both sides"
}