resource "aws_ram_resource_share" "vpc_2_subnets_shared" {
  name                      = "vpc_2_subnets_shared"
  allow_external_principals = false   # only inside the same AWS Org
}


resource "aws_ram_principal_association" "vpc_2_access" {
  resource_share_arn = aws_ram_resource_share.vpc_2_subnets_shared.arn
  principal          = var.prod_account_id
}


resource "aws_ram_resource_association" "vpc_2_subnets" {
  count              = length(var.vpc_2_subnet_arns)
  resource_share_arn = aws_ram_resource_share.vpc_2_subnets_shared.arn
  resource_arn       = var.vpc_2_subnet_arns[count.index]
}
