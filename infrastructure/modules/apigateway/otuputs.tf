output "api_endpoint" {
  description = "URI of the API, of the form https://{api-id}.execute-api."
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "apigateway_execution_arn" {
  description = "ARN of the API."
  value       = aws_apigatewayv2_api.this.execution_arn
}
