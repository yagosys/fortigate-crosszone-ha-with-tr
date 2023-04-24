
output "ack1_worknode_ip" {
value = alicloud_cs_managed_kubernetes.k8s_ack1[*].connections
}
