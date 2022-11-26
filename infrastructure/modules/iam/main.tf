resource "aws_iam_role" "lambda" {
  name = "${var.service_name}-${var.environment_identifier}-role-lambda"

  managed_policy_arns = [
    aws_iam_policy.lambda_ddb_write_access.arn,
    aws_iam_policy.lambda_ddb_read_access.arn
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-role-lambda"
  }
}

resource "aws_iam_policy" "lambda_ddb_write_access" {
  name = "${var.service_name}-${var.environment_identifier}-policy-lambda-ddb-write-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["dynamodb:PutItem"]
        Effect   = "Allow"
        Resource = var.ddb_table_arn
      },
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_ddb_read_access" {
  name = "${var.service_name}-${var.environment_identifier}-policy-lambda-ddb-read-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "dynamodb:DescribeTable",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = var.ddb_table_arn
      }
    ]
  })
}
