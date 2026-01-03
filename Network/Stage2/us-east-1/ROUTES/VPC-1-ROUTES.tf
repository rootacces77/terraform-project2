#Route from VPC-1 (us-east-1) to (eu-central-1)
resource "aws_route" "vpc_1_vpn_sub_vpc_2c" {
  route_table_id         = var.vpc-1-vpn-rt-id
  destination_cidr_block = var.vpc-us-west-1-cidr
  transit_gateway_id     = var.tgw-id
}

#Route from VPC-1 (us-east-1) to (us-west-1)
resource "aws_route" "vpc_1_vpn_sub_vpc_2w" {
  route_table_id         = var.vpc-1-vpn-rt-id
  destination_cidr_block = var.vpc-eu-central-1-cidr
  transit_gateway_id     = var.tgw-id
}