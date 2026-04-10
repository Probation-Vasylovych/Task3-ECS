output "task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  value = aws_ecs_task_definition.this.family
}

output "task_definition_revision" {
  value = aws_ecs_task_definition.this.revision
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.grafana.name
}