output "tgw_id" {
    value = aws_ec2_transit_gateway.this.id
    description = "TGW ID"
}

output "tgw_peering_id" {
    value = aws_ec2_transit_gateway_peering_attachment.tgw_peering.id
    description = "TGW Peering ID between eu_central_1 and us_east_1"
  
}

output "tgw_rt_id" {
    value = aws_ec2_transit_gateway_route_table.rt_main.id
    description = "TGW Main RT ID"
  
}

output "tgw_arn" {
    value = aws_ec2_transit_gateway.this.arn
  
}