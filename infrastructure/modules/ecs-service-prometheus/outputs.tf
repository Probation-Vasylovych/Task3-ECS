output "service_name" {
  description = "Prometheus ECS service name"
  value       = aws_ecs_service.this.name
}

output "service_id" {
  description = "Prometheus ECS service ID"
  value       = aws_ecs_service.this.id
}