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

################################################################################
# DynamoDB
################################################################################
variable "ddb_hash_key" {
  description = "Attribute to use as the hash (partition) key. Must also be defined as an attribute."
  type        = string
  default     = ""
}

variable "ddb_attributes" {
  description = "The list of Attriutes for DynamoDB Table."
  type        = list(map(string))
  default     = []
}

################################################################################
# Lambda
################################################################################
variable "lambda_runtime" {
  description = "The runtime of lambda"
  type        = string
  default     = ""
}
