terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}
resource "aws_apigatewayv2_api" "lambda" {
  name          = "api-gateway-ton"
  protocol_type = "HTTP"
}
resource "aws_cloudwatch_log_group" "ton_api" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.ton_api.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/dist"
  output_path = "nodejs.zip"
}

resource "aws_cloudwatch_log_group" "increment_lambda" {
  name              = "/aws/lambda/${aws_lambda_function.increment_lambda.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_function" "increment_lambda" {
  filename         = "nodejs.zip"
  function_name    = "increment_lambda"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "handler/IncrementPeopleHandler.incrementPeople"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
}


resource "aws_apigatewayv2_integration" "increment_lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.increment_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "increment_lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /increment"
  target    = "integrations/${aws_apigatewayv2_integration.increment_lambda.id}"
}



resource "aws_cloudwatch_log_group" "get_access_lambda" {
  name              = "/aws/lambda/${aws_lambda_function.get_access_lambda.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_function" "get_access_lambda" {
  filename         = "nodejs.zip"
  function_name    = "get_access_lambda"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "handler/GetTotalHandler.getTotalHandler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
}


resource "aws_apigatewayv2_integration" "get_access_lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.get_access_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_access_lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /acess/{namespace}/{key}"
  target    = "integrations/${aws_apigatewayv2_integration.get_access_lambda.id}"
}

resource "aws_cloudwatch_log_group" "create_users" {
  name              = "/aws/lambda/${aws_lambda_function.create_users.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_function" "create_users" {
  filename         = "nodejs.zip"
  function_name    = "create_users"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "handler/CreateUserHandler.createUser"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
}


resource "aws_apigatewayv2_integration" "create_users" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.create_users.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "create_users" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /user"
  target    = "integrations/${aws_apigatewayv2_integration.get_access_lambda.id}"
}



resource "aws_cloudwatch_log_group" "get_users" {
  name              = "/aws/lambda/${aws_lambda_function.get_users.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_function" "get_users" {
  filename         = "nodejs.zip"
  function_name    = "get_users"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "handler/GetUserHandler.getUser"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs14.x"
}


resource "aws_apigatewayv2_integration" "get_users" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.get_users.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_users" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /user/{email}"
  target    = "integrations/${aws_apigatewayv2_integration.get_access_lambda.id}"
}


resource "aws_lambda_permission" "ton_api" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.increment_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}


resource "aws_dynamodb_table" "user_tablee" {
  name           = "Users"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "email"
  range_key      = "key"

  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "key"
    type = "S"
  }

}




