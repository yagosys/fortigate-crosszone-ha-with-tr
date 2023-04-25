output "ack2_cluster_ip" {
value = alicloud_cs_managed_kubernetes.k8s_ack2[*].connections
}
