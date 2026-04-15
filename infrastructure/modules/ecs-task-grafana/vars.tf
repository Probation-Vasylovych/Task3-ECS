variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "grafana_image" {
  type = string
}

variable "execution_role_arn" {
  type = string
}


variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "alloy_image" {
  type = string
}