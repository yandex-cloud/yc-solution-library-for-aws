resource "yandex_mdb_postgresql_cluster" "pg" {
  name        = "demo-pg"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.pg.id

  config {
    version = 13
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }
    postgresql_config = {
      max_connections                   = 395
      enable_parallel_hash              = true
      vacuum_cleanup_index_scale_factor = 0.2
      autovacuum_vacuum_scale_factor    = 0.34
      default_transaction_isolation     = "TRANSACTION_ISOLATION_READ_COMMITTED"
      shared_preload_libraries          = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
    }
  }

  database {
    name  = var.db_name
    owner = var.db_user
  }

  user {
    name       = var.db_user
    password   = var.db_password
    conn_limit = 50
    permission {
      database_name = var.db_name
    }
    settings = {
      default_transaction_isolation = "read committed"
      log_min_duration_statement    = 5000
    }
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.pg.id
    assign_public_ip = true
  }
}

resource "yandex_vpc_network" "pg" {}

resource "yandex_vpc_subnet" "pg" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.pg.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}

resource "yandex_vpc_default_security_group" "default-sg" {
  description = "default security group"
  network_id  = "${yandex_vpc_network.pg.id}"

  egress {
    description    = "Permit ALL" 
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "ANY"
    predefined_target = "self_security_group"
  }

  ingress {
    description    = "ICMP"
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "PostgreSQL"
    protocol       = "TCP"
    port           = var.db_port
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

}

## Yandex Data Transfer:
## AWS RDS PostgreSQL instance --> YC MDB PostgreSQL instance
## https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/datatransfer_transfer

resource "yandex_datatransfer_endpoint" "dt_source_aws_rds" {
  count = var.dt_enable == false ? 0 : 1
  name = "aws-rds-pg"
  settings {
    postgres_source {
      connection {
        on_premise {
          hosts = [ aws_db_instance.this.address ]
          port  = var.db_port
        }
      }
      slot_gigabyte_lag_limit = 100
      database = var.db_name
      user     = var.db_user
      password {
        raw = var.db_password
      }
    }
  }
}

resource "yandex_datatransfer_endpoint" "dt_target_yc_mdb" {
  count = var.dt_enable == false ? 0 : 1
  name = "yc-mdb-pg"
  settings {
    postgres_target {
      connection {
        mdb_cluster_id = yandex_mdb_postgresql_cluster.pg.id
      }
      database = var.db_name
      user     = var.db_user
      password {
        raw = var.db_password
      }
    }
  }
}

resource "yandex_datatransfer_transfer" "dt_transfer" {
  count = var.dt_enable == false ? 0 : 1
  name      = "awspg-ycpg"
  source_id = yandex_datatransfer_endpoint.dt_source_aws_rds[count.index].id
  target_id = yandex_datatransfer_endpoint.dt_target_yc_mdb[count.index].id
  type      = "SNAPSHOT_AND_INCREMENT"
}
