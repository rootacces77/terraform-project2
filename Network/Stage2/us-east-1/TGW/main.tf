resource "aws_ec2_transit_gateway_peering_attachment_accepter" "eu_cental_1" {
  transit_gateway_attachment_id  = var.tgw_peering_id_eu_central_1

  tags = { Name = "tgw_peering_eu_central_1_accept" }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "us_west_1" {
  transit_gateway_attachment_id  = var.tgw_peering_id_us_west_1

  tags = { Name = "tgw_peering_us_west_1_accept" }
}


#CREATE ATTACHMENT FOR TGW PEERING CONNECTION (eu_central_1) TO MAIN ROUTE TABLE
resource "aws_ec2_transit_gateway_route_table_association" "peer_assoc_eu_central_1" {
  transit_gateway_attachment_id  = var.tgw_peering_id_eu_central_1
  transit_gateway_route_table_id = var.tgw_rt_id
}

#CREATE ATTACHMENT FOR TGW PEERING CONNECTION (us_west_1) TO MAIN ROUTE TABLE
resource "aws_ec2_transit_gateway_route_table_association" "peer_assoc_us_west_1" {
  transit_gateway_attachment_id  = var.tgw_peering_id_us_west_1
  transit_gateway_route_table_id = var.tgw_rt_id
}

# us_east_1 TGW RT: route to EU Central VPC CIDR via EU peering attachment
resource "aws_ec2_transit_gateway_route" "to_eu_central_1" {
  transit_gateway_route_table_id = var.tgw_rt_id
  destination_cidr_block         = var.vpc_eu_central_1_cidr
  transit_gateway_attachment_id  = var.tgw_peering_id_eu_central_1
}

# us_east_1 TGW RT: route to us_west_1 VPC CIDR via us_west peering attachment
resource "aws_ec2_transit_gateway_route" "to_us_west_1" {
  transit_gateway_route_table_id = var.tgw_rt_id
  destination_cidr_block         = var.vpc_us_west_1_cidr
  transit_gateway_attachment_id  = var.tgw_peering_id_us_west_1
}