resource "aws_ec2_transit_gateway_peering_attachment_accepter" "eu-cental-1" {
  transit_gateway_attachment_id  = var.tgw-peering-id-eu-central-1

  tags = { Name = "tgw-peering-eu-central-1-accept" }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "us-west-1" {
  transit_gateway_attachment_id  = var.tgw-peering-id-us-west-1

  tags = { Name = "tgw-peering-us-west-1-accept" }
}


#CREATE ATTACHMENT FOR TGW PEERING CONNECTION (eu-central-1) TO MAIN ROUTE TABLE
resource "aws_ec2_transit_gateway_route_table_association" "peer_assoc_eu-central-1" {
  transit_gateway_attachment_id  = var.tgw-peering-id-eu-central-1
  transit_gateway_route_table_id = var.tgw-rt-id
}

#CREATE ATTACHMENT FOR TGW PEERING CONNECTION (us-west-1) TO MAIN ROUTE TABLE
resource "aws_ec2_transit_gateway_route_table_association" "peer_assoc_us-west-1" {
  transit_gateway_attachment_id  = var.tgw-peering-id-us-west-1
  transit_gateway_route_table_id = var.tgw-rt-id
}

#PROPAGATE EU-CENTRAL-1 INTO MAIN ROUTE TABLE
resource "aws_ec2_transit_gateway_route_table_propagation" "prop-eu-central-1" {
  transit_gateway_attachment_id  = var.tgw-peering-id-eu-central-1
  transit_gateway_route_table_id = var.tgw-rt-id
}

#PROPAGATE US-WEST-1 INTO MAIN ROUTE TABLE
resource "aws_ec2_transit_gateway_route_table_propagation" "prop-us-west-1" {
  transit_gateway_attachment_id  = var.tgw-peering-id-us-west-1
  transit_gateway_route_table_id = var.tgw-rt-id
}