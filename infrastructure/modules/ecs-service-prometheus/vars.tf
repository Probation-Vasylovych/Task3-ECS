variable "project" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "cluster_arn" {
  type        = string
  description = "ECS cluster ID or ARN"
}

variable "task_definition_arn" {
  type        = string
  description = "Prometheus task definition ARN"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for ECS service"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for Prometheus ECS service"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for resources"
  default     = {}
}

variable "service_discovery_service_arn" {
  type = string
}