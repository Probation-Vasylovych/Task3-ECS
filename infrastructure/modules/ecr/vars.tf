variable "repositories" {
  description = "Map of ECR repositories"
  type        = map(string)
}

variable "common_tags" {
  description = "Common tags for all repositories"
  type        = map(string)
}

variable "push_principal_arn" {
  description = "IAM principal ARN allowed to push images to ECR repositories"
  type        = string
}
