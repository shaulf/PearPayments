resource "aws_cognito_user_pool" "PearP" {
  name = "PearP-user-pool"

  schema {
    attribute_data_type = "String"
    name               = "email"
    required           = true
  }

  schema {
    attribute_data_type = "String"
    name               = "custom_attribute"
    required           = false
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }
}
