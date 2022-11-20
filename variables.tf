variable "service_name" {
  description = "Service Name"
  type        = string
}

variable "environment_identifier" {
  description = "Environment identifier"
  type        = string
  default     = ""
}

variable "profile" {
  description = "AWS Configuretion Profile"
  type        = string
  default     = ""
}

variable "region" {
  description = "The region name"
  type        = string
  default     = ""
}
