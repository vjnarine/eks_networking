resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.nat_subnet.id
}

resource "aws_route_table" "nat_igw_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "nat_igw_rta" {
  route_table_id = aws_route_table.nat_igw_rt.id
  subnet_id = aws_subnet.nat_subnet.id
}


# associate nat_gateway with the so worker nodes
resource "aws_route_table" "worker_nat_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    nat_gateway_id = aws_nat_gateway.ngw.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "worker_nat_rta" {
  count = length(aws_subnet.worker_subnets.*.id)
  subnet_id = element(aws_subnet.worker_subnets.*.id,count.index)
  route_table_id = aws_route_table.worker_nat_rt.id
}