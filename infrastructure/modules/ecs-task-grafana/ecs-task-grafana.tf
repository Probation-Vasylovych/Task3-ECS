resource "aws_cloudwatch_log_group" "grafana" {
  name              = "/ecs/${var.project}-${var.env}-grafana"
  retention_in_days = 7

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-grafana-logs"
  })
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project}-${var.env}-grafana"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "grafana"
      image     = var.grafana_image
      essential = true

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "GF_SERVER_ROOT_URL"
          value = "https://birdswatching.pp.ua/grafana/"
        },
        {
          name  = "GF_SERVER_SERVE_FROM_SUB_PATH"
          value = "true"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-${var.env}-grafana"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    },

    {
      name      = "alloy"
      image     = var.alloy_image
      essential = false

      environment = [
        {
          name  = "MONITORED_SERVICE"
          value = "grafana"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-${var.env}-grafana"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "alloy"
        }
      }
    }

  ])

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-grafana-task"
  })
}