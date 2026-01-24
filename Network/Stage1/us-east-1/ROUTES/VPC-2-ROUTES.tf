#Route from VPC_2 to VPC_1
resource "aws_route" "vpc_2_private1_sub_vpc_1" {
  route_table_id         = var.vpc_2_private1_rt_id
  destination_cidr_block = var.vpc_2_cidr
  transit_gateway_id     = var.tgw_id
}