resource "aws_cloudwatch_log_group" "web" {
  name              = "/ecs/${var.project}-${var.env}-web"
  retention_in_days = 7

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-web-logs"
  })
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project}-${var.env}-web"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = var.web_image
      essential = true

      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "OLLAMA_BASE_URL"
          value = "http://ollama.internal.local:11434"
        },

        {
  name  = "ENABLE_OTEL"
  value = "true"
},
{
  name  = "ENABLE_OTEL_METRICS"
  value = "true"
},
{
  name  = "ENABLE_OTEL_TRACES"
  value = "true"
},
{
  name  = "OTEL_EXPORTER_OTLP_ENDPOINT"
  value = "http://127.0.0.1:4317"
},
{
  name  = "OTEL_EXPORTER_OTLP_INSECURE"
  value = "true"
},
{
  name  = "OTEL_SERVICE_NAME"
  value = "open-webui"
}
      ]

      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = var.database_url_secret_arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-${var.env}-web"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    },

  {
    name      = "alloy"
    image     = var.alloy_image
    essential = false

    portMappings = [
      {
        containerPort = 4317
        protocol      = "tcp"
      },
      {
        containerPort = 4318
        protocol      = "tcp"
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${var.project}-${var.env}-web"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "alloy"
      }
    }
  }

  ])
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-web-task"
  })
}