module "tgw" {
    source = "./TGW"

    peering_attachment_id = var.peering_attachment_id
    route_table_id        = var.route_table_id
  
}