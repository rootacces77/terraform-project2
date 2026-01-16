output "kinesis_steam_A_arn" {
    value = aws_kinesis_stream.lambdaA.arn
  
}

output "kinesis_steam_B_arn" {
    value = aws_kinesis_stream.lambdaB
  
}