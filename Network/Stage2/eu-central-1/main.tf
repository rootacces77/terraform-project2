module "tgw" {
    source = "./TGW"

    peering_attachment_id = var.tgw_peering_attachment_id
    route_table_id        = var.tgw_route_table_id
  
}