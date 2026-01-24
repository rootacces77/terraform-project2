############################################
# Transit Gateway
############################################
resource "aws_ec2_transit_gateway" "this" {
  description                     = "${var.tgw_name}_tgw"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "${var.tgw_name}_tgw"
  }
}

############################################
# TGW Route Tables
############################################
resource "aws_ec2_transit_gateway_route_table" "rt_main" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "${var.tgw_name}_tgw_rt_main"
  }
}



############################################
# VPC Attachments
############################################
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_1" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc_1_id
  subnet_ids         = var.vpc_1_subnet_ids

  dns_support  = "enable"
  ipv6_support = "disable"

  tags = {
    Name = "${var.tgw_name}_attach_vpc_1"
  }
}


############################################
# Associations (decide which TGW RT is used
# for traffic COMING FROM each VPC)
############################################
# VPC_A traffic uses rt_main (so A can route to B)
resource "aws_ec2_transit_gateway_route_table_association" "assoc_a" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_main.id
}

############################################
# Propagation into rt_main (so rt_main learns
# where VPC_B lives; you can also do static routes)
############################################
resource "aws_ec2_transit_gateway_route_table_propagation" "prop_1_into_main" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_main.id
}

############################################
# TGW Attachments (eu_central_1 _> us_east_1)
############################################
resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peering" {
  transit_gateway_id      = aws_ec2_transit_gateway.this.id
  peer_transit_gateway_id = var.us_east_1_tgw_id
  peer_region             = var.region_name


  tags = {
    Name = "${var.tgw_name}_attach_${var.region_name}_tgw"
  }
}
