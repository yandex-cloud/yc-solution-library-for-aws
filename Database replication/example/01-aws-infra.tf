provider "aws" {
  region = "eu-central-1"
}

#############################################################
# Data sources to get VPC, subnets and security group details
#############################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

resource "aws_security_group_rule" "sg1" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.db_port
  to_port           = var.db_port
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.default.id
}

# ======================
# Create DB Subnet Group
# ======================
resource "aws_db_subnet_group" "this" {
  name        = var.identifier
  description = "Database subnet group for ${var.identifier}"
  subnet_ids  = data.aws_subnet_ids.all.ids
}

# =========================
# Create DB Parameter Group
# =========================
resource "aws_db_parameter_group" "default" {
  name   = "rds-postgress"
  family = "postgres13"

  parameter {
    apply_method = "pending-reboot"
    name         = "rds.logical_replication"
    value        = "1"
  }
}

# ======================
# Create RDS DB Instance
# ======================
resource "aws_db_instance" "this" {
  identifier              = var.identifier
  engine                  = "postgres"
  engine_version          = "13"
  instance_class          = "db.t3.micro"
  allocated_storage       = 5
  storage_encrypted       = false
  port                    = var.db_port

  name                    = var.db_name
  username                = var.db_user
  password                = var.db_password
  publicly_accessible     = true 
  skip_final_snapshot     = true
  backup_retention_period = 0
  deletion_protection     = false

  vpc_security_group_ids  = [data.aws_security_group.default.id]
  db_subnet_group_name    = aws_db_subnet_group.this.name
  parameter_group_name    = aws_db_parameter_group.default.name
}
