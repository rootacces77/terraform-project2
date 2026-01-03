output "tgw-id" {
    value = aws_ec2_transit_gateway.this.id
    description = "TGW ID"
}

output "tgw-peering-id" {
    value = aws_ec2_transit_gateway_peering_attachment.tgw-peering.id
    description = "TGW Peering ID between eu-central-1 and us-east-1"
  
}

output "tgw-rt-id" {
    value = aws_ec2_transit_gateway_route_table.rt_main.id
    description = "TGW Main RT ID"
  
}

output "tgw-arn" {
    value = aws_ec2_transit_gateway.this.arn
  
}