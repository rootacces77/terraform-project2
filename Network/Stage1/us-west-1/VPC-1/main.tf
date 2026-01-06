resource "aws_vpc" "vpc_1" {
  cidr_block           = "10.18.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "VPC_1"
    Terraform   = "true"
  }
}

resource "aws_internet_gateway" "vpc_1_igw" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name        = "VPC_1_IGW"
    Terraform   = "true"
  }
}

########################
# SUBNETS CIDR
########################
locals {
  vpc_1_public_subnets = {
    "us_west_1a" = "10.18.0.0/20"
#    "us_west_1b" = "10.18.16.0/20"
    "us_west_1c" = "10.18.32.0/20"
  }
  vpc_1_vpn_subnets = {
    "us_west_1a" = "10.18.48.0/20"
 #   "us_west_1b" = "10.18.64.0/20"
    "us_west_1c" = "10.18.80.0/20"
  }
  vpc_1_private_subnets = {
    "us_west_1a" = "10.18.96.0/20"
 #   "us_west_1b" = "10.18.112.0/20"
    "us_west_1c" = "10.18.128.0/20"
  }
}

########################
# PUBLIC SUBNETS
########################

resource "aws_subnet" "vpc_1_public" {
  for_each = local.vpc_1_public_subnets

  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name        = "VPC_1_SBNT_PUBLIC"
    Tier        = "PUBLIC"
    Terraform   = "true"
  }
}

#NAT

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat_eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.vpc_1_public["us_west_1a"].id

  tags = {
    Name = "nat_gw_public_1"
  }
}



#RT
resource "aws_route_table" "vpc_1_public_rt" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name        = "VPC_1_PUBLIC_RT"
    Terraform   = "true"
  }
}

resource "aws_route_table_association" "vpc_1_public_rt" {
  for_each       = aws_subnet.vpc_1_public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_1_public_rt.id
}

resource "aws_route" "vpc_1_public_igw_route" {
  route_table_id         = aws_route_table.vpc_1_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_1_igw.id
}

########################
# ClientVPN SUBNETS
########################

resource "aws_subnet" "vpc_1_vpn" {
  for_each = local.vpc_1_vpn_subnets

  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "VPC_1_SBNT_VPN"
    Tier        = "VPN"
    Terraform   = "true"
  }
}

resource "aws_route_table" "vpc_1_vpn_rt" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name        = "VPC_1_VPN_RT"
    Terraform   = "true"
  }
}

resource "aws_route_table_association" "vpc_1_vpn_rt" {
  for_each       = aws_subnet.vpc_1_vpn
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_1_vpn_rt.id
}



########################
# PRIVATE SUBNETS
########################

resource "aws_subnet" "vpc_1_private" {
  for_each = local.vpc_1_private_subnets

  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "VPC_1_SBNT_PRIVATE"
    Tier        = "PRIVATE"
    Terraform   = "true"
  }
}

resource "aws_route_table" "vpc_1_private_rt" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name        = "VPC_1_PRIVATE_RT"
    Terraform   = "true"
  }
}


resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.vpc_1_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "vpc_1_private_rt" {
  for_each       = aws_subnet.vpc_1_private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_1_private_rt.id
}