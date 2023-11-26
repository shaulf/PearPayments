resource "aws_api_gateway_rest_api" "pearpRest" {
  name        = "pearpRest-api"
  description = "pearpRest API"
}

resource "aws_api_gateway_resource" "trasact" {
  rest_api_id = aws_api_gateway_rest_api.pearpRest.id
  parent_id   = aws_api_gateway_rest_api.pearpRest.root_resource_id
  path_part   = "trasact"
}

resource "aws_api_gateway_resource" "audit" {
  rest_api_id = aws_api_gateway_rest_api.pearpRest.id
  parent_id   = aws_api_gateway_rest_api.pearpRest.root_resource_id
  path_part   = "audit"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.pearpRest.id
  resource_id   = aws_api_gateway_resource.trasact.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.pearpRest.id
  resource_id             = aws_api_gateway_resource.trasact.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.post_function.invoke_arn
}

resource "aws_lambda_permission" "post_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_function.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_method" "get_method_1" {
  rest_api_id   = aws_api_gateway_rest_api.pearpRest.id
  resource_id   = aws_api_gateway_resource.trasact.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_integration_1" {
  rest_api_id             = aws_api_gateway_rest_api.pearpRest.id
  resource_id             = aws_api_gateway_resource.trasact.id
  http_method             = aws_api_gateway_method.get_method_1.http_method
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = aws_lambda_function.get_function_1.invoke_arn
}

resource "aws_api_gateway_integration_response" "post_integration_response_200" {
  depends_on        = [aws_api_gateway_method.get_method_1]
  rest_api_id       = aws_api_gateway_rest_api.pearpRest.id
  resource_id       = aws_api_gateway_resource.trasact.id
  http_method       = aws_api_gateway_method.get_method_1.http_method
  status_code       = "200"
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "get_lambda_permission_1" {
  statement_id  = "AllowAPIGatewayInvoke_1"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_function_1.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_method" "get_method_2" {
  rest_api_id   = aws_api_gateway_rest_api.pearpRest.id
  resource_id   = aws_api_gateway_resource.audit.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_integration_2" {
  rest_api_id             = aws_api_gateway_rest_api.pearpRest.id
  resource_id             = aws_api_gateway_resource.audit.id
  http_method             = aws_api_gateway_method.get_method_2.http_method
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = aws_lambda_function.get_function_2.invoke_arn
}

resource "aws_api_gateway_integration_response" "post_integration_response_200_get_method_2" {
  depends_on        = [aws_api_gateway_method.get_method_2]
  rest_api_id       = aws_api_gateway_rest_api.pearpRest.id
  resource_id       = aws_api_gateway_resource.audit.id
  http_method       = aws_api_gateway_method.get_method_2.http_method
  status_code       = "200"
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_stage" "dev" {
  depends_on    = [aws_api_gateway_rest_api.pearpRest]
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.pearpRest.id
  deployment_id = aws_api_gateway_deployment.dev_deployment.id

  # Other stage configurations...
}

resource "aws_api_gateway_deployment" "dev_deployment" {
  depends_on = [aws_api_gateway_rest_api.pearpRest]
  rest_api_id = aws_api_gateway_rest_api.pearpRest.id
  #stage_name  = aws_api_gateway_stage.dev.stage_name

  # Other deployment configurations...
}

resource "aws_iam_role" "api_gateway_execution_role" {
  name = "api-gateway-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "api_gateway_execution_policy" {
  name        = "api-gateway-execution-policy"
  description = "Policy for API Gateway Execution Role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
      # Add more statements for additional permissions if needed
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_execution_role_attachment" {
  policy_arn = aws_iam_policy.api_gateway_execution_policy.arn
  role       = aws_iam_role.api_gateway_execution_role.name
}
