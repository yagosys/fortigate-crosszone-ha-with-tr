resource "alicloud_security_group" "SecGroup_ack1" {
  name        = "${var.cluster_name}-SecGroup-${random_string.random_name_post.result}"
  description = "SecurityGroup for ACK worknode instance"
  vpc_id      = alicloud_vpc.ack1_vpc_default.id
}

//Allow All Ingress for Firewall
resource "alicloud_security_group_rule" "allow_all_tcp_ingress_ack1" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.SecGroup_ack1.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_cs_managed_kubernetes" "k8s_ack1" {
  count = var.ack1_vpc =="1" ? 1 :0
  name                  = "${var.k8s_name_prefix == "" ? format("%s-%s", var.example_name_ack1, format(var.number_format, count.index+1)) : format("%s-%s", var.k8s_name_prefix, format(var.number_format, count.index+1))}"
  availability_zone     = data.alicloud_zones.default.zones[0].id
  worker_vswitch_ids = [alicloud_vswitch.ack1_vswitch0.id,alicloud_vswitch.ack1_vswitch1.id]
  pod_vswitch_ids= [alicloud_vswitch.ack1_vswitch0.id,alicloud_vswitch.ack1_vswitch1.id]
  new_nat_gateway       = false
  worker_instance_types = ["${var.worker_instance_type == "" ? data.alicloud_instance_types.ack1_default.instance_types.0.id : var.worker_instance_type}"]
  worker_number         = "${var.k8s_worker_number}"
  worker_disk_category  = "${var.worker_disk_category}"
  worker_disk_size      = "${var.worker_disk_size}"
  password              = "${var.ecs_password}"
  pod_cidr              = "${var.k8s_pod_cidr}"
  service_cidr          = "${var.k8s_service_cidr}"
  slb_internet_enabled  = false
  security_group_id = alicloud_security_group.SecGroup_ack1.id
  install_cloud_monitor = false
 // cluster_spec = "ack.pro.small"
  kube_config           = "~/.kube/config_ack1"

  dynamic "addons" {
      for_each = var.cluster_addons_ack1
      content {
        name          = lookup(addons.value, "name", var.cluster_addons_ack1)
        config        = lookup(addons.value, "config", var.cluster_addons_ack1)
        disabled      = lookup(addons.value, "disabled", var.cluster_addons_ack1)
      }
  }
}

variable "cluster_addons_ack1" {
  type = list(object({
    name      = string
    config    = string
    disabled  = bool
  }))

  default = [
    {
      "name"     = "terway-eniip",
      "config"   = "",
      "disabled" = false,
    },
    {  "name"    = "nginx-ingress-controller",
       "config"  = "",
       "disabled" = true,
    }
  ]
}
