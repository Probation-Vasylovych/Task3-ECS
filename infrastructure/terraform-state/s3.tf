resource "aws_s3_bucket" "tf_state" {
  bucket = "llm-ecs"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "tf_state_https_policy" {
  bucket = aws_s3_bucket.tf_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "ExamplePolicy"
    Statement = [
      {
        Sid    = "HTTPSOnly"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.tf_state.arn,
          "${aws_s3_bucket.tf_state.arn}/*",
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
    ]
  })
}

resource "aws_s3_bucket_logging" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "testing-logs"
}

resource "aws_s3_bucket" "logs" {
  bucket = "tf-state-logs-llm-ecs"
}

data "aws_iam_policy_document" "logs" {
  statement {
    sid    = "s3-log-delivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.logs.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.logs.json
}

resource "aws_s3_bucket_public_access_block" "tf_state_logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}