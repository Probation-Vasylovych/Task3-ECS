variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "web_image" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "database_url_secret_arn" {
  type = string
}

variable "alloy_image" {
  type = string
}

variable "task_role_arn" {
  type = string
}