data "aws_iam_policy_document" "ecs_task_execution_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution_role" {
  name               = "${var.project}-${var.env}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role.json

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-ecs-execution-role"
  })
}

resource "aws_iam_role_policy_attachment" "execution_role_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "read_openwebui_db_secret" {
  name        = "${var.project}-${var.env}-read-openwebui-db-secret"
  description = "Allow ECS execution role to read OpenWebUI database secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.openwebui_database_url_secret_arn
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-read-openwebui-db-secret"
  })
}

resource "aws_iam_role_policy_attachment" "read_openwebui_db_secret" {
  role       = aws_iam_role.execution_role.name
  policy_arn = aws_iam_policy.read_openwebui_db_secret.arn
}