variable "service_name" {
  description = "Service Name"
  type        = string
}

variable "environment_identifier" {
  description = "Environment identifier"
  type        = string
  default     = ""
}

variable "cognito_user_pool_endpoint" {
  description = "Endpoint name of the user pool. Example format: cognito-idp.REGION.amazonaws.com/xxxx_yyyyy"
  type        = string
  default     = ""
}

variable "cognito_user_pool_client_id" {
  description = "The client id of Cognito User Pool Client"
  type        = string
  default     = ""
}

variable "lambda_function_arn_index" {
  description = "Amazon Resource Name (ARN) identifying your Lambda Function."
  type        = string
  default     = ""
}

variable "lambda_function_arn_create" {
  description = "Amazon Resource Name (ARN) identifying your Lambda Function."
  type        = string
  default     = ""
}
