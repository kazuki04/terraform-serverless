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

variable "ddb_table_arn" {
  description = "ARN of the table"
  type        = string
  default     = ""
}
