output "service_id" {
  value = aws_service_discovery_service.this.id
}

output "service_arn" {
  value = aws_service_discovery_service.this.arn
}

output "service_name" {
  value = aws_service_discovery_service.this.name
}