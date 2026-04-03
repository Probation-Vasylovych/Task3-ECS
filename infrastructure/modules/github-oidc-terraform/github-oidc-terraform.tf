data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [
        "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
      ]
    }
  }
}

resource "aws_iam_role" "github_terraform_role" {
  name               = "github-actions-terraform-role"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  tags = merge(
    var.common_tags,
    {
      Name = "github-actions-terraform-role"
    }
  )
}

data "aws_iam_policy_document" "terraform_backend_s3" {
  statement {
    sid    = "ListStateBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::llm-ecs"
    ]
  }

  statement {
    sid    = "ReadWriteStateFile"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::llm-ecs/ecs/llm-ecs.tfstate"
    ]
  }

  statement {
    sid    = "ManageLockFile"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::llm-ecs/ecs/llm-ecs.tfstate.tflock"
    ]
  }
}

resource "aws_iam_policy" "terraform_backend_s3" {
  name   = "github-actions-terraform-backend-s3-policy"
  policy = data.aws_iam_policy_document.terraform_backend_s3.json

  tags = merge(
    var.common_tags,
    {
      Name = "github-actions-terraform-backend-s3-policy"
    }
  )
}

resource "aws_iam_role_policy_attachment" "terraform_backend_s3" {
  role       = aws_iam_role.github_terraform_role.name
  policy_arn = aws_iam_policy.terraform_backend_s3.arn
}