resource "aws_ecr_repository" "this" {
  for_each = var.repositories

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(
    var.common_tags,
    {
      Name    = each.value
      Service = each.key
    }
  )
}

data "aws_iam_policy_document" "repository_policy" {
  for_each = aws_ecr_repository.this

  statement {
    sid    = "AllowPushFromGitHubOIDCRole"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [var.push_principal_arn]
    }

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
  }
}

resource "aws_ecr_repository_policy" "this" {
  for_each = aws_ecr_repository.this

  repository = each.value.name
  policy     = data.aws_iam_policy_document.repository_policy[each.key].json
}
