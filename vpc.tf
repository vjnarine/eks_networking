resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : var.vpc_name
    Cluster: var.cluster_name
  }
}

output "eks_vpc_id" {
  value = aws_vpc.eks_vpc.id
}