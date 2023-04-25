use 
```
terraform init
terraform apply 
```
to deploy after properly set varilables in tfvars file.

after deploy, you shall able to get similar result like below giving default tfvars config.

```
ActiveFortigateEIP3 = [

  "8.218.211.114",
]
PrimaryFortigateAdminGUI_PORT = "8443"
PrimaryFortigateAvailability_zone = "cn-hongkong-b"
PrimaryFortigateID = "i-j6c3l29wv5lp2g55aaux"
PrimaryFortigatePrivateIP = "192.168.11.11"
PrimaryFortigatePublicIP = ""
PrimaryFortigate_MGMT_EIP = [
  "47.242.197.68",
]
PrimaryFortigateport2IP = [
  "192.168.12.11",
]
SecondaryFortigateAdminGUI_PORT = "8443"
SecondaryFortigateAvailability_zone = [
  "cn-hongkong-c",
]
SecondaryFortigateID = [
  "i-j6c0bihfvzh2j9z1krnn",
]
SecondaryFortigatePrivateIP = [
  "192.168.21.12",
]
SecondaryFortigatePublicIP = [
  "",
]
SecondaryFortigate_MGMT_EIP = [
  "8.218.210.136",
]
SecondaryFortigateport2IP = "192.168.22.12"
ack1_cluster_ip = [
  tomap({
    "api_server_internet" = ""
    "api_server_intranet" = "https://10.1.0.93:6443"
    "service_domain" = "*.c887a5fd0d7274c73a3005bc1c2698f75.cn-hongkong.alicontainer.com"
  }),
]
ack2_cluster_ip = [
  tomap({
    "api_server_internet" = ""
    "api_server_intranet" = "https://10.0.0.92:6443"
    "service_domain" = "*.c02ead5bd123d42b28e0684df0640ff62.cn-hongkong.alicontainer.com"
  }),
]
client-vm = [
  "",
]
client-vm-login_public_ip = [
  "8.218.211.114",
]
client-vm-password = "Welcome.123"
client-vm-ssh-port = "2022"
client-vm-user-name = "root"
```

based on above result (`terraform output`). 
use 
`ssh root@8.218.211.114 -p 2022` to login into linux client vm.
from linux client vm, use `kubectl1 get node` and `kubectl2 get node` to display ack worker node IP address in ack1 vpc and ack2 vpc.
below you can login to worker node 10.1.1.129, from 10.1.1.129 , you can ping 10.0.1.98 throught TR and Fortigate . also both nodes are able to access internet via Fortigate. 

```
 ssh root@8.218.211.114 -p 2022
Warning: Permanently added '[8.218.211.114]:2022' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-101-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge
New release '20.04.6 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Welcome to Alibaba Cloud Elastic Compute Service !

Last login: Tue Apr 25 09:10:36 2023 from 192.168.12.11
root@iZj6cehhiq63h4jginff7zZ:~# kubectl1 get node -o wide
NAME                     STATUS   ROLES    AGE   VERSION            INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                                         KERNEL-VERSION            CONTAINER-RUNTIME
cn-hongkong.10.1.1.129   Ready    <none>   11m   v1.24.6-aliyun.1   10.1.1.129    <none>        Alibaba Cloud Linux (Aliyun Linux) 2.1903 LTS (Hunting Beagle)   4.19.91-26.6.al7.x86_64   containerd://1.5.13
root@iZj6cehhiq63h4jginff7zZ:~# kubectl2 get node -o wide
NAME                    STATUS   ROLES    AGE   VERSION            INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                                         KERNEL-VERSION            CONTAINER-RUNTIME
cn-hongkong.10.0.1.98   Ready    <none>   11m   v1.24.6-aliyun.1   10.0.1.98     <none>        Alibaba Cloud Linux (Aliyun Linux) 2.1903 LTS (Hunting Beagle)   4.19.91-26.6.al7.x86_64   containerd://1.5.13
root@iZj6cehhiq63h4jginff7zZ:~# ssh root@10.0.1.98 
The authenticity of host '10.0.1.98 (10.0.1.98)' can't be established.
ECDSA key fingerprint is SHA256:FJcn7vnc1gDswCbW1xBermA/LrBpyOVCw83aP7qzh9o.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.0.1.98' (ECDSA) to the list of known hosts.
root@10.0.1.98's password: 

Welcome to Alibaba Cloud Elastic Compute Service !

User Tips:
For better compatibility, Alibaba Cloud Linux 2 manages network settings via
network-scripts by default instead of former systemd-networkd.
More details please refer to:
https://help.aliyun.com/knowledge_detail/182049.html

5 package(s) needed for security, out of 19 available
Run "yum update" to apply all updates.More details please refer to:
https://help.aliyun.com/document_detail/416274.html
[root@iZj6cia6bytx1kbz7fpcyfZ ~]# ping 10.1.1.129
PING 10.1.1.129 (10.1.1.129) 56(84) bytes of data.
64 bytes from 10.1.1.129: icmp_seq=1 ttl=61 time=2.16 ms
^C
--- 10.1.1.129 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 2.168/2.168/2.168/0.000 ms
[root@iZj6cia6bytx1kbz7fpcyfZ ~]# 

```
