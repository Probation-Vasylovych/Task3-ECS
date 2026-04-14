resource "aws_ecs_service" "this" {
  name                              = "${var.project}-${var.env}-web-service"
  cluster                           = var.cluster_arn
  task_definition                   = var.task_definition_arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 300

  load_balancer {
    target_group_arn = var.web_target_group_arn
    container_name   = "web"
    container_port   = 8080
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.web_security_group_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = var.service_discovery_service_arn
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-web-service"
  })
}