resource "aws_cloudwatch_log_group" "ollama" {
  name              = "/ecs/${var.project}-${var.env}-ollama"
  retention_in_days = 7

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-ollama-logs"
  })
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project}-${var.env}-ollama"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "ollama"
      image     = var.ollama_image
      essential = true

      portMappings = [
        {
          containerPort = 11434
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "OLLAMA_HOST"
          value = "0.0.0.0:11434"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-${var.env}-ollama"
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
          value = "ollama"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-${var.env}-ollama"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "alloy"
        }
      }
    }
  ])

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-ollama-task"
  })
}