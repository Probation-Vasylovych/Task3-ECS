resource "aws_ecs_service" "this" {
  name            = "${var.project}-${var.env}-ollama-service"
  cluster         = var.cluster_arn
  task_definition = var.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ollama_security_group_id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = var.service_discovery_service_arn
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-ollama-service"
  })
}