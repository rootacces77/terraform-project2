############################################
# Transit Gateway
############################################
resource "aws_ec2_transit_gateway" "this" {
  description                     = "${var.tgw-name}-tgw"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name = "${var.tgw-name}-tgw"
  }
}

############################################
# TGW Route Tables
############################################
resource "aws_ec2_transit_gateway_route_table" "rt_main" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "${var.tgw-name}-tgw-rt-main"
  }
}

resource "aws_ec2_transit_gateway_route_table" "rt_isolated" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "${var.tgw-name}-tgw-rt-isolated"
  }
}

############################################
# VPC Attachments
############################################
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_1" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc-1-id
  subnet_ids         = var.vpc-1-subnet-ids

  dns_support  = "enable"
  ipv6_support = "disable"

  tags = {
    Name = "${var.tgw-name}-attach-vpc-1"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_2" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc-2-id
  subnet_ids         = var.vpc-2-subnet-ids

  dns_support  = "enable"
  ipv6_support = "disable"

  tags = {
    Name = "${var.tgw-name}-attach-vpc-2"
  }
}

############################################
# Associations (decide which TGW RT is used
# for traffic COMING FROM each VPC)
############################################
# VPC-A traffic uses rt_main (so A can route to B)
resource "aws_ec2_transit_gateway_route_table_association" "assoc_a" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_main.id
}

# VPC-B traffic uses rt_isolated (no routes => B can't reach others)
resource "aws_ec2_transit_gateway_route_table_association" "assoc_b" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_isolated.id
}

############################################
# Propagation into rt_main (so rt_main learns
# where VPC-B lives; you can also do static routes)
############################################
resource "aws_ec2_transit_gateway_route_table_propagation" "prop_b_into_main" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_main.id
}