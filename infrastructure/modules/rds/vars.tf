variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "private_rds_subnet_ids" {
  type = list(string)
}

variable "rds_security_group_id" {
  type = string
}

variable "db_name" {
  type    = string
  default = "openwebui"
}

variable "db_username" {
  type    = string
  default = "openwebui"
}

variable "engine_version" {
  type    = string
  default = "16.4"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type    = number
  default = 100
}

variable "common_tags" {
  type    = map(string)
  default = {}
}