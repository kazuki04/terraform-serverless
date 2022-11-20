data "archive_file" "this" {
  type             = "zip"
  source_file      = "${path.root}/../program/functions/index.js"
  output_file_mode = "0666"
  output_path      = "${path.module}/files/index.js.zip"
}

resource "aws_lambda_function" "this" {
  filename         = "${data.archive_file.this.output_path}"
  function_name    = "${var.service_name}-${var.environment_identifier}-lambda"
  role             = var.role_arn_lambda
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = "${data.archive_file.this.output_base64sha256}"

  depends_on = [
    aws_cloudwatch_log_group.this
  ]

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-lambda"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.service_name}-${var.environment_identifier}-lambda"
  retention_in_days = 90
}
