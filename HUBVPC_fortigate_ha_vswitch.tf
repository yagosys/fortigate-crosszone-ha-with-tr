resource "alicloud_vswitch" "ha_ap_unicast_a" {
  vswitch_name      = "ha_ap_unicast_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_3
  zone_id = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "ha_ap_unicast_b" {
  vswitch_name              = "ha_ap_unicast_b"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_3
  zone_id = data.alicloud_zones.default.zones.1.id
}

resource "alicloud_vswitch" "mgmt_a" {
  vswitch_name              = "mgmt_a"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_a_cidr_4
  zone_id = data.alicloud_zones.default.zones.0.id
}

resource "alicloud_vswitch" "mgmt_b" {
  vswitch_name              = "mgmt_b"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vswitch_b_cidr_4
  zone_id = data.alicloud_zones.default.zones.1.id
}
