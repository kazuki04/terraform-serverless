resource "aws_dynamodb_table" "this" {
  name           = "${var.service_name}-${var.environment_identifier}-ddb-table"
  billing_mode   = "PROVISIONED"
  hash_key       = var.ddb_hash_key
  read_capacity  = 1
  write_capacity = 1

  dynamic "attribute" {
    for_each = var.ddb_attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-ddb-table"
  }
}
