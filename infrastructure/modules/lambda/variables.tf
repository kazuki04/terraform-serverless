variable "service_name" {
  description = "Service Name"
  type        = string
  default     = ""
}

variable "environment_identifier" {
  description = "Environment identifier"
  type        = string
  default     = ""
}

variable "role_arn_lambda" {
  description = "The ARN of role for lambda"
  type        = string
  default     = ""
}

variable "lambda_runtime" {
  description = "The runtime of lambda"
  type        = string
  default     = ""
}

variable "api_endpoint" {
  description = "The URL of API Gateway endpoint"
  type        = string
  default     = ""
}

variable "apigateway_execution_arn" {
  description = "ARN of the API."
  type        = string
  default     = ""
}

variable "ddb_table_arn" {
  description = "ARN of the DynamoDB tabale."
  type        = string
  default     = ""
}
