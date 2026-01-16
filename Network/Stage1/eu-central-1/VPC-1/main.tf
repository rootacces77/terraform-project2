resource "aws_vpc" "vpc_1" {
  cidr_block           = "10.19.0.0/16"
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
    "eu-central-1a" = "10.19.0.0/20"
    "eu-central-1b" = "10.19.16.0/20"
    "eu-central-1c" = "10.19.32.0/20"
  }
  vpc_1_private1_subnets = {
    "eu-central-1a" = "10.19.48.0/20"
    "eu-central-1b" = "10.19.64.0/20"
    "eu-central-1c" = "10.19.80.0/20"
  }
  vpc_1_private2_subnets = {
    "eu-central-1a" = "10.19.96.0/20"
    "eu-central-1b" = "10.19.112.0/20"
    "eu-central-1c" = "10.19.128.0/20"
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
# PRIVATE SUBNETS
########################

resource "aws_subnet" "vpc_1_private1" {
  for_each = local.vpc_1_private1_subnets

  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "VPC_1_SBNT_PRIVATE1"
    Tier        = "PRIVATE1"
    Terraform   = "true"
  }
}

resource "aws_route_table" "vpc_1_private1_rt" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name        = "VPC_1_VPN_RT"
    Terraform   = "true"
  }
}

resource "aws_route_table_association" "vpc_1_vpn_rt" {
  for_each       = aws_subnet.vpc_1_private1
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_1_private1_rt.id
}



########################
# PRIVATE SUBNETS
########################

resource "aws_subnet" "vpc_1_private2" {
  for_each = local.vpc_1_private2_subnets

  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "VPC_1_SBNT_PRIVATE2"
    Tier        = "PRIVATE2"
    Terraform   = "true"
  }
}

resource "aws_route_table" "vpc_1_private2_rt" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name        = "VPC_1_PRIVATE2_RT"
    Terraform   = "true"
  }
}

resource "aws_route_table_association" "vpc_1_private2_rt" {
  for_each       = aws_subnet.vpc_1_private2
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_1_private2_rt.id
}