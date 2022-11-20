resource "aws_cognito_user_pool" "this" {
  name                     = "${var.service_name}-${var.environment_identifier}-cognito-pool"
  auto_verified_attributes = [ "email" ]
  alias_attributes         = [ "email" ]

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_uppercase                = true
    require_symbols                  = false
    temporary_password_validity_days = 7
  }

  username_configuration {
    case_sensitive = true
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "${var.service_name}-${var.environment_identifier}-cognito-client"

  user_pool_id        = aws_cognito_user_pool.this.id
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}