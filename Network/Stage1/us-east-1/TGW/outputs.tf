output "tgw-id" {
    value = aws_ec2_transit_gateway.this.id
    description = "ID of TGW"
  
}

output "tgw-arn" {
    value = aws_ec2_transit_gateway.this.arn
  
}

output "tgw-rt-id" {
    value = aws_ec2_transit_gateway_route_table.rt_main.id
  
}