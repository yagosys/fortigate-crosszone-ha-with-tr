output "client-vm" {
// value = coalesce(alicloud_instance.client-vm.*.public_ip,alicloud_instance.client-vm.*.private_ip)
value =  var.client-vm=="1" ? coalesce(alicloud_instance.client-vm.*.public_ip,alicloud_instance.client-vm.*.private_ip) : null
}

output "client-vm-login_public_ip" {
  value = var.eip=="1" && var.client-vm=="1" ? alicloud_eip.PublicInternetIp.*.ip_address : null
}

output "client-vm-user-name" {
value = var.client-vm=="1" ? "root" : null
}

output "client-vm-ssh-port" {
  value = var.client-vm=="1" ? var.client_vm_ssh_port : null
}

output "client-vm-password" {
  value = var.client-vm=="1" ? var.client_vm_password : null
}
