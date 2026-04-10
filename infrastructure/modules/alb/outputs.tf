output "alb_id" {
  description = "ALB ID"
  value       = aws_lb.this.id
}

output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "ALB hosted zone ID"
  value       = aws_lb.this.zone_id
}

output "https_listener_arn" {
  description = "HTTPS listener ARN"
  value       = aws_lb_listener.https.arn
}

output "web_target_group_arn" {
  description = "Web target group ARN"
  value       = aws_lb_target_group.web_v3.arn
}

output "grafana_target_group_arn" {
  description = "Grafana target group ARN"
  value       = aws_lb_target_group.grafana.arn
}