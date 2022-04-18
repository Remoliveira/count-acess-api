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

# resource "aws_api_gateway_rest_api" "ton_test" {
#   body = jsonencode({
#     openapi = "3.0.1"
#     info = {
#       title   = "ton_test"
#       version = "1.0"
#     }
#     paths = {
#       "/ton" = {
#         get = {
#           x-amazon-apigateway-integration = {
#             httpMethod           = "GET"
#             payloadFormatVersion = "1.0"
#             type                 = "HTTP_PROXY"
#             uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
#           }
#         }
#       }
#     }
#   })

#   name = "ton_test"

#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# resource "aws_api_gateway_deployment" "ton_test" {
#   rest_api_id = aws_api_gateway_rest_api.ton_test.id

#   triggers = {
#     redeployment = sha1(jsonencode(aws_api_gateway_rest_api.ton_test.body))
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_api_gateway_stage" "ton_test" {
#   deployment_id = aws_api_gateway_deployment.ton_test.id
#   rest_api_id   = aws_api_gateway_rest_api.ton_test.id
#   stage_name    = "ton_test"
# }


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
  source_file = "./src/handler/IncrementPeople.js"
  output_path = "increment_lambda_function.zip"
}

resource "aws_cloudwatch_log_group" "increment_lambda" {
  name              = "/aws/lambda/${aws_lambda_function.increment_lambda.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_function" "increment_lambda" {
  filename         = "increment_lambda_function.zip"
  function_name    = "increment_lambda"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "dist/src/handler/IncrementPeopleHandler.handler"
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

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.increment_lambda.id}"
}





resource "aws_lambda_permission" "ton_api" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.increment_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}




