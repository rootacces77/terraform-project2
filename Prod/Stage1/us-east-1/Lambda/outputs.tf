
output "lambda_invoke_arn" {
    value = aws_lambda_function.writer.arn
  
}

output "lambda_function_name" {
    value = aws_lambda_function.writer.function_name
  
}