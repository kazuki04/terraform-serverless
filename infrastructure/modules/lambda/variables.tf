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
