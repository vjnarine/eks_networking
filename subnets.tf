resource "aws_subnet" "worker_subnets" {
  count = length(var.workers_cidr_block)
  cidr_block = element(var.workers_cidr_block,count.index )
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    # refer
    "kubernetes.io/cluster/${var.cluster_name}" : "shared"
    "Cluster": var.cluster_name
    "Name": "EKS_WORKER_${count.index}"
    "Type": "Worker"
  }
}

resource "aws_subnet" "nat_subnet" {
  cidr_block = var.nat_cidr_block
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    "Type" : "NAT"
    "Name": "EKS_NAT"
  }
}

resource "aws_subnet" "lb_subnets" {
  count = length(var.lb_cidr_block)
  cidr_block = element(var.lb_cidr_block,count.index )
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    # refer
    "kubernetes.io/cluster/${var.cluster_name}" : "shared"
    "kubernetes.io/role/internal-elb": 1
    "Cluster": var.cluster_name
    "Name": "EKS_LB_${count.index}"
    "Type": "LB"
  }
}

output "worker_subnets" {
  value = tolist(aws_subnet.worker_subnets.*.id)
}