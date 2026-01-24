#Route from VPC_1 ( subnet PRIVATE 1) to VPC_1 US-EAST-1
resource "aws_route" "vpc_1_vpn_sub_vpc_2" {
  route_table_id         = var.vpc_1_private1_rt_id
  destination_cidr_block = var.vpc_1_us_east_1_cidr
  transit_gateway_id     = var.tgw_id
}