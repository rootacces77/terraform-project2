resource "aws_ec2_transit_gateway_route_table_association" "peer_assoc" {
  transit_gateway_attachment_id  = var.peering_attachment_id
  transit_gateway_route_table_id = var.route_table_id
}