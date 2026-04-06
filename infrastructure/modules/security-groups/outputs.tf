output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "web_service_security_group_id" {
  description = "Web service security group ID"
  value       = aws_security_group.web_service.id
}

output "ollama_service_security_group_id" {
  description = "Ollama service security group ID"
  value       = aws_security_group.ollama_service.id
}

output "grafana_service_security_group_id" {
  description = "Grafana service security group ID"
  value       = aws_security_group.grafana_service.id
}

output "prometheus_service_security_group_id" {
  description = "Prometheus service security group ID"
  value       = aws_security_group.prometheus_service.id
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}