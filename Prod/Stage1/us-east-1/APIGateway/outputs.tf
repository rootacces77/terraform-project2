output "api_gateway_stage_name" {
    value = aws_api_gateway_stage.this.stage_name
  
}

output "apigw_invoke_domain_name" {
    value = "${aws_api_gateway_rest_api.this.id}.execute-api.us-east-1.amazonaws.com"
  
}