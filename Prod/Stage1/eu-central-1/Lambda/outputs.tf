output "lambdaA_arn" {
    value = aws_lambda_function.writerA.arn
  
}

output "lambdaB_arn" {
    value = aws_lambda_function.writerB.arn
  
}

output "lambdaA_function_name" {
    value = aws_lambda_function.writerA.function_name
  
}

output "lambdaB_function_name" {
    value = aws_lambda_function.writerB.function_name
  
}