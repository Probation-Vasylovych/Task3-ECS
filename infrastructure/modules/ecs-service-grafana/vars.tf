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

variable "security_group_id" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "service_discovery_service_arn" {
  type = string
}

variable "target_group_arn" {
  type = string
}