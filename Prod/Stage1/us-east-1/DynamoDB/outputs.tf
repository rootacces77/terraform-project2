output "dynamodb_table_arn" {
   value = aws_dynamodb_table.kv.arn
  
}

output "dynamodb_table_name" {
    value = aws_dynamodb_table.kv.name
  
}