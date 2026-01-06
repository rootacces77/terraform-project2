#Route from VPC_1 (us_east_1) to (eu_central_1)
resource "aws_route" "vpc_1_vpn_sub_vpc_2c" {
  route_table_id         = var.vpc_1_vpn_rt_id
  destination_cidr_block = var.vpc_us_west_1_cidr
  transit_gateway_id     = var.tgw_id
}

#Route from VPC_1 (us_east_1) to (us_west_1)
resource "aws_route" "vpc_1_vpn_sub_vpc_2w" {
  route_table_id         = var.vpc_1_vpn_rt_id
  destination_cidr_block = var.vpc_eu_central_1_cidr
  transit_gateway_id     = var.tgw_id
}