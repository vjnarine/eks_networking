variable "cluster_name" {}

variable "vpc_name" {}
variable "vpc_cidr_block" {}

variable "workers_cidr_block" { type=list(string)}

# for public and private EKS configuration, worker nodes must be able to speak to internet
variable "nat_cidr_block" {}
variable "lb_cidr_block" {}