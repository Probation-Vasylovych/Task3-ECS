resource "aws_ecs_cluster" "this" {
  name = "llm-${var.env}-cluster"

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "llm-${var.env}-cluster"
    }
  )
}