output "execution_role_arn" {
  description = "ECS task execution role ARN"
  value       = aws_iam_role.execution_role.arn
}