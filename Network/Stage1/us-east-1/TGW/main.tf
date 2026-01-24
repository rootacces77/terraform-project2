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

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_2" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc_2_id
  subnet_ids         = var.vpc_2_subnet_ids

  dns_support  = "enable"
  ipv6_support = "disable"

  tags = {
    Name = "${var.tgw_name}_attach_vpc_2"
  }
}

############################################
# Associations (decide which TGW RT is used
# for traffic COMING FROM each VPC)
############################################
# VPC_A traffic uses rt_main 
resource "aws_ec2_transit_gateway_route_table_association" "assoc_1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_main.id
}

# VPC_B traffic uses rt_main 
resource "aws_ec2_transit_gateway_route_table_association" "assoc_2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_main.id
}

############################################
# Propagation into rt_main (so rt_main learns
# where VPC_B lives; you can also do static routes)
############################################
resource "aws_ec2_transit_gateway_route_table_propagation" "prop_2_into_main" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_main.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "prop_1_into_main" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_main.id
}