//# common variables

variable "ack1_vpc" {
  default = "1"
}

variable "availability_zone" {
  description = "The available zone to launch ecs instance and other resources."
  default     = ""
}

variable "number_format" {
  description = "The number format used to output."
  default     = "%02d"
}

variable "example_name_ack1" {
  default = "ack1"
}

# Instance typs variables
variable "client_vm_cpu_core_count" {
  description = "CPU core count is used to fetch instance types."
  default     = 1
}

variable "client_vm_memory_size" {
  description = "Memory size used to fetch instance types."
  default     = 2
}

# Cluster nodes variables

variable "worker_instance_type" {
  description = "The ecs instance type used to launch worker nodes. Default from instance typs datasource."
  default     = "ecs.hfc6.xlarge"
}

variable "worker_disk_category" {
  description = "The system disk category used to launch one or more worker nodes."
  default     = "cloud_efficiency"
}

variable "worker_disk_size" {
  description = "The system disk size used to launch one or more worker nodes."
  default     = "20"
}

variable "ecs_password" {
  description = "The password of instance."
  default     = "Welcome.123"
}

variable "k8s_worker_number" {
  description = "The number of worker nodes in each kubernetes cluster."
  default     = 1
}

variable "k8s_name_prefix" {
  description = "The name prefix used to create several kubernetes clusters. Default to variable `example_name`"
  default     = ""
}

variable "k8s_pod_cidr" {
  description = "The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them."
  default     = "10.1.0.0/23"
}

variable "k8s_service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them."
  default     = "172.21.0.0/20"
}

variable ack1_vpc_cidr {
   type = string
   default = "10.1.0.0/16"
}

variable ack1_vswitch0_subnet {
    type = string
    default = "10.1.0.0/24"
}

variable ack1_vswitch1_subnet {
    type = string
    default = "10.1.1.0/24"
}
