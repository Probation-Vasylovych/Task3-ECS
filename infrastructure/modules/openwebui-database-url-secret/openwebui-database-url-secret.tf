data "aws_secretsmanager_secret_version" "rds_master" {
  secret_id = var.rds_master_secret_arn
}

locals {
  rds_secret       = jsondecode(data.aws_secretsmanager_secret_version.rds_master.secret_string)
  encoded_password = urlencode(local.rds_secret.password)

  database_url = "postgresql://${local.rds_secret.username}:${local.encoded_password}@${var.db_host}:${var.db_port}/${var.db_name}"
}

resource "aws_secretsmanager_secret" "this" {
  name = "${var.project}/${var.env}/openwebui/database-url-v1"

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-openwebui-database-url-v1"
  })
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = local.database_url
}