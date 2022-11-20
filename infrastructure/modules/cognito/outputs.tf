output "cognito_user_pool_endpoint" {
  description = "Endpoint name of the user pool. Example format: cognito-idp.REGION.amazonaws.com/xxxx_yyyyy"
  value       = aws_cognito_user_pool.this.endpoint
}

output "cognito_user_pool_client_id" {
  description = "ID of the user pool client."
  value       = aws_cognito_user_pool_client.this.id
}
