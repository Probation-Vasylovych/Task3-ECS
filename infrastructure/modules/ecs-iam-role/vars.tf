variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}

variable "openwebui_database_url_secret_arn" {
  type        = string
  description = "ARN of Secrets Manager secret with OpenWebUI DATABASE_URL"
}