variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "cluster_arn" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "web_security_group_id" {
  type = string
}

variable "web_target_group_arn" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "service_discovery_service_arn" {
  type = string
}