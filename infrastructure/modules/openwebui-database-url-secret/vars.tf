variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "rds_master_secret_arn" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_port" {
  type = number
}

variable "db_name" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}