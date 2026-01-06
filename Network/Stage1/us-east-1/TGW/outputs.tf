output "tgw_id" {
    value = aws_ec2_transit_gateway.this.id
    description = "ID of TGW"
  
}

output "tgw_arn" {
    value = aws_ec2_transit_gateway.this.arn
  
}

output "tgw_rt_id" {
    value = aws_ec2_transit_gateway_route_table.rt_main.id
  
}