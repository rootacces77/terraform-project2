output "kinesis_stream_A_arn" {
    value = aws_kinesis_stream.lambdaA.arn
  
}

output "kinesis_stream_B_arn" {
    value = aws_kinesis_stream.lambdaB.arn
  
}

output "kinesis_stream_A_name" {
    value = aws_kinesis_stream.lambdaA.name
  
}

output "kinesis_stream_B_name" {
    value = aws_kinesis_stream.lambdaB.name
  
}