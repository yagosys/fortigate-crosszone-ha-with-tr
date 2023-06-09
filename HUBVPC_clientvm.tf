
data "alicloud_instance_types" "client_vm_types_ds" {
  cpu_core_count = 2
  memory_size    = 4
}

variable "fadLicense" {
  default = "./FADV040000225874.lic"
}

resource "alicloud_instance" "client-vm" {
  count = var.client-vm =="1" ? 1 :0
  depends_on = [alicloud_cen_transit_router_vpc_attachment.atta_fortiadc]
  image_id        = "ubuntu_18_04_x64_20G_alibase_20200521.vhd"
  internet_max_bandwidth_out = var.client_vm_internet_max_bandwidth_out=="1" ? 10 : null
  security_groups = alicloud_security_group.SecGroup.*.id
  instance_type = var.client_vm_instance_type
  instance_name              = "client-ubuntu-${random_string.random_name_post.result}"
  vswitch_id                 = alicloud_vswitch.internal_a_0.id
  key_name          = alicloud_key_pair.example.key_name
  password= var.client_vm_password
  private_ip = var.client_vm_private_ip
  tags = {
    Name = "Terraform-clientvm"
  }
  provisioner "file" {
      source = "~/.kube/config_ack1"
      destination ="/root/kubeconfig_ack1" 
   }
 
  provisioner "file" {
      source = "~/.kube/config_ack2"
      destination ="/root/kubeconfig_ack2"
}

 provisioner "file" {
      source = "./kubectl"
      destination = "/root/kubectl"
}

 provisioner "file" {
      source ="./k8s_nginx_deployment.yaml"
      destination = "/root/k8s_nginx_deployment.yaml"
}

 provisioner "file" {
      source = "./k8s_svc_nginx.yaml"
      destination = "/root/k8s_svc_nginx.yaml"
}

  provisioner "remote-exec" {
     inline = [
       "echo curl -LO \"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\"",
       "sleep 2",
       "sudo install -o root -g root -m 0755 /root/kubectl /usr/local/bin/kubectl",
       "sleep 2",
       "mkdir -p /root/.kube",
       "mv /root/kubeconfig_ack2 /root/.kube/config_ack2",
       "mv /root/kubeconfig_ack1 /root/.kube/config_ack1",
       "kubectl cluster-info --kubeconfig=/root/.kube/config_ack1",
       "kubectl cluster-info --kubeconfig=/root/.kube/config_ack2",
       "kubectl apply -f k8s_nginx_deployment.yaml --kubeconfig=/root/.kube/config_ack1",
       "kubectl apply -f k8s_svc_nginx.yaml --kubeconfig=/root/.kube/config_ack1",
       "kubectl apply -f k8s_nginx_deployment.yaml --kubeconfig=/root/.kube/config_ack2",
       "kubectl apply -f k8s_svc_nginx.yaml --kubeconfig=/root/.kube/config_ack2",
       "kubectl cluster-info --kubeconfig=/root/.kube/config_ack2",
       "kubectl cluster-info --kubeconfig=/root/.kube/config_ack1",
       "kubectl get node -o wide --kubeconfig=/root/.kube/config_ack2",
       "kubectl get node -o wide --kubeconfig=/root/.kube/config_ack1",
       "echo alias kubectl1=\"'kubectl --kubeconfig=/root/.kube/config_ack1'\" >>~/.bashrc",
       "echo alias kubectl2=\"'kubectl --kubeconfig=/root/.kube/config_ack2'\" >>~/.bashrc",
       ".  ~/.bashrc",
       "kubectl1 get pod -o wide",
       "kubectl2 get pod -o wide"

     ]
   }

connection {
//  host = "${alicloud_instance.PrimaryFortigate.public_ip}"
//host = "${element(aws_instance.example.*.public_ip, count.index)}"
  host= var.eip=="1" ? "${element(alicloud_eip.PublicInternetIp.*.ip_address,0)}" : alicloud_instance.PrimaryFortigate.public_ip
  type = "ssh"
  port = "${var.client_vm_ssh_port}"
  user = "${var.client_vm_username}"
  timeout = "180s"
  password = "${var.client_vm_password}"
}

}


