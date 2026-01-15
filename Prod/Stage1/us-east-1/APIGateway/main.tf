#############################
# REST API
#############################
resource "aws_api_gateway_rest_api" "this" {
  name = "api-rest-api-lambda"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#############################
# Resource: /submit
#############################
resource "aws_api_gateway_resource" "submit" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "submit"
}

#############################
# Method: POST /submit
#############################
resource "aws_api_gateway_method" "submit_post" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.submit.id
  http_method   = "POST"
  authorization = "NONE"
}

# Lambda proxy integration
resource "aws_api_gateway_integration" "submit_post" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.submit.id
  http_method             = aws_api_gateway_method.submit_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
#  uri                     = var.lambda_invoke_arn
  uri =  "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${var.lambda_invoke_arn}/invocations"
}

#############################
# Permission: allow API GW to invoke Lambda
#############################
resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # Allow any stage/method on this API (scoped to this REST API ID)
  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

#############################
# Deployment + Stage (NO CORS)
#############################
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  # Force redeploy on changes to POST method/integration only
  triggers = {
    redeploy = sha1(jsonencode({
      post_method_id      = aws_api_gateway_method.submit_post.id
      post_integration_id = aws_api_gateway_integration.submit_post.id
    }))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.submit_post
  ]
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
  stage_name    = "main-stage"
}