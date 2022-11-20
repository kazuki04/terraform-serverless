output "role_arn_lambda" {
  description = "ARN of the role"
  value       = aws_iam_role.lambda.arn
}
