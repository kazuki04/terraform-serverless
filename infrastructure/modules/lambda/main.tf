locals {
  ddb_table_name = element(split("/", var.ddb_table_arn), 1)
}

################################################################################
# Index
################################################################################
data "archive_file" "index" {
  type             = "zip"
  source_file      = "${path.root}/../program/functions/article/index.py"
  output_file_mode = "0666"
  output_path      = "${path.module}/files/article/index.py.zip"
}

resource "aws_lambda_function" "index" {
  filename         = data.archive_file.index.output_path
  function_name    = "${var.service_name}-${var.environment_identifier}-lambda-article-index"
  role             = var.role_arn_lambda
  handler          = "index.lambda_handler"
  runtime          = var.lambda_runtime
  source_code_hash = data.archive_file.index.output_base64sha256

  environment {
    variables = {
      API_ENDPOINT   = var.api_endpoint
      DDB_TABLE_NAME = local.ddb_table_name
    }
  }

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-lambda-article-index"
  }
}

resource "aws_lambda_permission" "index" {
  statement_id  = "AllowExecutionFromApigatewayIndex"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.index.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apigateway_execution_arn}/*/*/api/v1/articles"
}

################################################################################
# Create
################################################################################
data "archive_file" "create" {
  type             = "zip"
  source_file      = "${path.root}/../program/functions//article/create.py"
  output_file_mode = "0666"
  output_path      = "${path.module}/files/article/create.py.zip"
}

resource "aws_lambda_function" "create" {
  filename         = data.archive_file.create.output_path
  function_name    = "${var.service_name}-${var.environment_identifier}-lambda-article-create"
  role             = var.role_arn_lambda
  handler          = "create.lambda_handler"
  runtime          = var.lambda_runtime
  source_code_hash = data.archive_file.create.output_base64sha256

  environment {
    variables = {
      API_ENDPOINT   = var.api_endpoint
      DDB_TABLE_NAME = local.ddb_table_name
    }
  }

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-lambda-article-create"
  }
}

resource "aws_lambda_permission" "create" {
  statement_id  = "AllowExecutionFromApigatewayCreate"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apigateway_execution_arn}/*/*/api/v1/article"
}
