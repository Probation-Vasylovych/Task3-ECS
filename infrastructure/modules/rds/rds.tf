resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-${var.env}-db-subnet-group"
  subnet_ids = var.private_rds_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-db-subnet-group"
  })
}

resource "aws_db_instance" "this" {
  identifier = "${var.project}-${var.env}-postgres"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  username                    = var.db_username
  manage_master_user_password = true
  db_name                     = var.db_name
  port                        = 5432

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_security_group_id]

  publicly_accessible        = false
  multi_az                   = false
  backup_retention_period    = 7
  deletion_protection        = false
  skip_final_snapshot        = true
  auto_minor_version_upgrade = true

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-postgres"
  })
}