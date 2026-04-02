variable "github_org" {
  description = "GitHub organization or username"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to assume the role"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "ecr_repository_names" {
  description = "List of ECR repository names that GitHub can push to"
  type        = map(string)
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}