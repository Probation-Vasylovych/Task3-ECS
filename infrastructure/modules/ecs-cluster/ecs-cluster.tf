resource "aws_ecs_cluster" "this" {
  name = "llm-${var.env}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "llm-${var.env}-cluster"
    }
  )
}