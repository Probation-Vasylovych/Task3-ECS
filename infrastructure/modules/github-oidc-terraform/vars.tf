variable "github_org" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "github_branch" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "github_oidc_provider_arn" {
  description = "ARN of GitHub Actions OIDC provider"
  type        = string
}

variable "rds_master_secret_arn" {
  description = "ARN of RDS master secret in Secrets Manager"
  type        = string
}