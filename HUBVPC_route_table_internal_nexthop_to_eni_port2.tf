resource "alicloud_route_entry" "internal_rt_default_route_to_eni" {
  depends_on            = [alicloud_network_interface.PrimaryFortiGateInterface1]
  count                 = 1
  route_table_id        = alicloud_route_table.custom_route_tables[count.index].id
  destination_cidrblock = var.default_egress_route 
  nexthop_type          = "NetworkInterface"
  name                  = alicloud_network_interface.PrimaryFortiGateInterface1.id
  nexthop_id            = alicloud_network_interface.PrimaryFortiGateInterface1.id
}
