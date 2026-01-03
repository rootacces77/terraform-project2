module "tgw" {
    source = "./TGW"

    peering_attachment_id = var.tgw-peering_attachment_id
    route_table_id        = var.tgw-route_table_id
  
}