resource "aws_apigatewayv2_api" "this" {
  name          = "${var.service_name}-${var.environment_identifier}-apigateway"
  description   = "The API for ${var.service_name} in ${var.environment_identifier} environment"
  protocol_type = "HTTP"

  cors_configuration {
      allow_headers     = ["Content-Type", "Authorization"]
      allow_methods     = ["GET", "POST"]
      allow_origins     = ["http://localhost:3000"]
      allow_credentials = true
  }

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

resource "aws_apigatewayv2_deployment" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  description = "Deployment in ${var.environment_identifier} in environment"

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_api.this),
      jsonencode(aws_apigatewayv2_integration.create),
      jsonencode(aws_apigatewayv2_route.create),
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

################################################################################
# Route
################################################################################
resource "aws_apigatewayv2_route" "index" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "GET /api/v1/articles"

  target             = "integrations/${aws_apigatewayv2_integration.index.id}"
  authorizer_id      = aws_apigatewayv2_authorizer.this.id
  authorization_type = "JWT"
}

resource "aws_apigatewayv2_integration" "index" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"

  connection_type      = "INTERNET"
  description          = "Lambda integration for ${var.service_name} in ${var.environment_identifier} environment"
  integration_method   = "GET"
  integration_uri      = var.lambda_function_arn_index
  passthrough_behavior = "WHEN_NO_MATCH"
}


resource "aws_apigatewayv2_route" "create" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /api/v1/article"

  target             = "integrations/${aws_apigatewayv2_integration.create.id}"
  authorizer_id      = aws_apigatewayv2_authorizer.this.id
  authorization_type = "JWT"
}

resource "aws_apigatewayv2_integration" "create" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"

  connection_type      = "INTERNET"
  description          = "Lambda integration for ${var.service_name} in ${var.environment_identifier} environment"
  integration_method   = "POST"
  integration_uri      = var.lambda_function_arn_create
  passthrough_behavior = "WHEN_NO_MATCH"
}
