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
