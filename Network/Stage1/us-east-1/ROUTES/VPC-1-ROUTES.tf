#Route from VPC-1 ( subnet VPN ) to VPC-2
resource "aws_route" "vpc_1_vpn_sub_vpc_2" {
  route_table_id         = var.vpc-1-vpn-rt-id
  destination_cidr_block = var.vpc-2-cidr
  transit_gateway_id     = var.tgw-id
}