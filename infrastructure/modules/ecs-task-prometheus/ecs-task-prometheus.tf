resource "aws_cloudwatch_log_group" "prometheus" {
  name              = "/ecs/${var.project}-${var.env}-prometheus"
  retention_in_days = 7

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-prometheus-logs"
  })
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project}-${var.env}-prometheus"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "prometheus"
      image     = var.prometheus_image
      essential = true

      portMappings = [
        {
          containerPort = 9090
          protocol      = "tcp"
        }
      ]

      command = [
        "--config.file=/etc/prometheus/prometheus.yml"
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-${var.env}-prometheus"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-prometheus-task"
  })
}