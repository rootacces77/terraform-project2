############################
# 1) Network Manager Global Network
############################
resource "aws_networkmanager_global_network" "this" {
  description = "Global Network view for TGWs (Network Manager)"

  tags = {
    Name = "global-tgw-network"
  }
}

############################
# 2) Register both TGWs into the Global Network
############################
resource "aws_networkmanager_transit_gateway_registration" "eu_central_1" {
  global_network_id   = aws_networkmanager_global_network.this.id
  transit_gateway_arn = var.tgw_arn_eu_central_1
}

resource "aws_networkmanager_transit_gateway_registration" "us_west_1" {
  global_network_id   = aws_networkmanager_global_network.this.id
  transit_gateway_arn = var.tgw_arn_us_west_1
}

resource "aws_networkmanager_transit_gateway_registration" "us-east-1" {
  global_network_id   = aws_networkmanager_global_network.this.id
  transit_gateway_arn = var.tgw_arn_us_east_1
}