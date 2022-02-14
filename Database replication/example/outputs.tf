output "db_name" {
  description = "The database name"
  value       = var.db_name
}

output "db_user" {
  description = "The username for the database"
  value       = aws_db_instance.this.username
}

output "db_passwd" {
  description = "The password for the database"
  value       = var.db_password
  sensitive   = true
}

output "db_port" {
  description = "The TCP port of DB instance"
  value       = var.db_port
}

output "yc_db_cluster_id" {
  description = "The YC PostgreSQL Cluster ID"
  value       = yandex_mdb_postgresql_cluster.pg.id
}

output "yc_db_host_fqdn" {
  description = "The YC PostgreSQL Cluster Hostname"
  value       = yandex_mdb_postgresql_cluster.pg.host[0].fqdn
}

output "aws_db_host_fqdn" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.this.address
}


/*
output "aws_db_instance_name" {
  description = "The AWS database name"
  value       = aws_db_instance.this.name
}

output "aws_db_instance_endpoint" {
  description = "The AWS connection endpoint"
  value       = aws_db_instance.this.endpoint
}

output "aws_db_instance_port" {
  description = "The AWS database port"
  value       = aws_db_instance.this.port
}

output "this_db_subnet_group_id" {
  description = "The db subnet group name"
  value       = element(concat(aws_db_subnet_group.this.*.id, [""]), 0)
}

output "this_db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = element(concat(aws_db_subnet_group.this.*.arn, [""]), 0)
}

output "this_db_parameter_group_id" {
  description = "The db parameter group id"
  value       = aws_db_parameter_group.default.id
}

output "this_db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = aws_db_parameter_group.default.arn
}

output "this_db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.this.address
}

output "this_db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.this.arn
}

output "this_db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = aws_db_instance.this.availability_zone
}

output "this_db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = aws_db_instance.this.hosted_zone_id
}

output "this_db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.this.id
}

output "this_db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = aws_db_instance.this.resource_id
}

output "this_db_instance_status" {
  description = "The RDS instance status"
  value       = aws_db_instance.this.status
}


output "this_db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.this.port
}
*/
