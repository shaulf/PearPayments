resource "aws_dynamodb_table" "pearP_DB" {
  name           = "pearP_table"
  billing_mode   = "PAY_PER_REQUEST"  # or "provisioned"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"  # String type for the hash key
  }

  # You can add more attributes and configuration options as needed
  # For example, provisioned throughput settings, secondary indexes, etc.
}