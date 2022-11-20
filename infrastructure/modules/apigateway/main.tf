resource "aws_apigatewayv2_api" "this" {
  name          = "${var.service_name}-${var.environment_identifier}-apigateway"
  description   = "The API for ${var.service_name} in ${var.environment_identifier} environment"
  protocol_type = "HTTP"

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-apigateway"
  }
}

# Authorizers
resource "aws_apigatewayv2_authorizer" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  name             = "${var.service_name}-${var.environment_identifier}-authorizer-cognito"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [var.cognito_user_pool_client_id]
    issuer   = "https://${var.cognito_user_pool_endpoint}"
  }
}

resource "aws_apigatewayv2_route" "ride" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /ride"

  target             = "integrations/${aws_apigatewayv2_integration.ride.id}"
  authorizer_id      = aws_apigatewayv2_authorizer.this.id
  authorization_type = "JWT"
}

resource "aws_apigatewayv2_integration" "ride" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"

  connection_type      = "INTERNET"
  description          = "Lambda integration for ${var.service_name} in ${var.environment_identifier} environment"
  integration_method   = "POST"
  integration_uri      = var.lambda_functio_arn
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_deployment" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  description = "Deployment in ${var.environment_identifier} in environment"

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.ride),
      jsonencode(aws_apigatewayv2_route.ride),
    ])))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_stage" "this" {
  api_id        = aws_apigatewayv2_api.this.id
  name          = var.environment_identifier
  deployment_id = aws_apigatewayv2_deployment.this.id
}
