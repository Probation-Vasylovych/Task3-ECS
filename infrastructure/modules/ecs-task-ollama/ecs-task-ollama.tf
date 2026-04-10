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
    }
  ])

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-ollama-task"
  })
}