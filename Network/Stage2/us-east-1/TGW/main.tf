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

# us-east-1 TGW RT: route to EU Central VPC CIDR via EU peering attachment
resource "aws_ec2_transit_gateway_route" "to_eu_central_1" {
  transit_gateway_route_table_id = var.tgw-rt-id
  destination_cidr_block         = var.vpc-eu-central-1-cidr
  transit_gateway_attachment_id  = var.tgw-peering-id-eu-central-1
}

# us-east-1 TGW RT: route to us-west-1 VPC CIDR via us-west peering attachment
resource "aws_ec2_transit_gateway_route" "to_us_west_1" {
  transit_gateway_route_table_id = var.tgw-rt-id
  destination_cidr_block         = var.vpc-us-west-1-cidr
  transit_gateway_attachment_id  = var.tgw-peering-id-us-west-1
}