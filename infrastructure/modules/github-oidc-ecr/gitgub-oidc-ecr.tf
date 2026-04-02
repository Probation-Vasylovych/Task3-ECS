resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]

  tags = merge(var.common_tags, {
    Name = "github-oidc-provider"
  })
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
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

resource "aws_iam_role" "github_ecr_role" {
  name               = "github-actions-ecr-role"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  tags = merge(var.common_tags, {
    Name = "github-actions-ecr-role"
  })
}

data "aws_iam_policy_document" "github_ecr_push" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = [
      for repo_name in var.ecr_repository_names :
      "arn:aws:ecr:${var.aws_region}:${var.aws_account_id}:repository/${repo_name}"
    ]
  }
}

resource "aws_iam_policy" "github_ecr_push" {
  name   = "github-actions-ecr-push-policy"
  policy = data.aws_iam_policy_document.github_ecr_push.json

  tags = merge(var.common_tags, {
    Name = "github-actions-ecr-push-policy"
  })
}

resource "aws_iam_role_policy_attachment" "github_ecr_push" {
  role       = aws_iam_role.github_ecr_role.name
  policy_arn = aws_iam_policy.github_ecr_push.arn
}