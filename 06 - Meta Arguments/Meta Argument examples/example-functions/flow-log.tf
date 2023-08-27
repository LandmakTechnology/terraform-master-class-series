resource "aws_cloudwatch_log_group" "example" {
  name       = "example-logs"
  kms_key_id = aws_kms_key.log_key.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "example" {
  name               = "example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "example" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:CreateLogDelivery",
      "logs:DeleteLogDelivery"
    ]

    resources = [aws_flow_log.main_vpc.arn]
  }
}

resource "aws_iam_role_policy" "example" {
  name   = "example-policy"
  role   = aws_iam_role.example.id
  policy = data.aws_iam_policy_document.example.json
}

data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

resource "aws_kms_key" "log_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "cloudWatch_logKey",
    Statement = [
      {
        Sid    = "KeyOwnerPolicy",
        Effect = "Allow",
        Principal = {
          AWS = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
        },
        Action = [
          "kms:*"
        ],
        Resource = "*",
      },
      {
        Sid    = "CWLogPolicy",
        Effect = "Allow",
        Principal = {
          Service = ["logs.${data.aws_region.this.name}.amazonaws.com"]
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*",
        Condition = {
          ArnLike = {
            "kms:EncryptionContext:aws:logs:arn" : ["arn:aws:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:*"
            ]
          }
        }
      }
    ]
  })
}