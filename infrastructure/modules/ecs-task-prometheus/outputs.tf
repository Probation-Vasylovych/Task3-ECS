output "task_definition_arn" {
  description = "Prometheus task definition ARN"
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "Prometheus task definition family"
  value       = aws_ecs_task_definition.this.family
}

output "task_definition_revision" {
  description = "Prometheus task definition revision"
  value       = aws_ecs_task_definition.this.revision
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.prometheus.name
}