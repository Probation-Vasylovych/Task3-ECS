variable "project" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment name (dev, prod, etc)"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "prometheus_image" {
  type        = string
  description = "Prometheus Docker image"
}

variable "execution_role_arn" {
  type        = string
  description = "ECS task execution role ARN"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for resources"
}

variable "alloy_image" {
  type = string
}