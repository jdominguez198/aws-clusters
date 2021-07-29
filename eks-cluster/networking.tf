resource "aws_vpc" "k8s_eks_vpc" {
  cidr_block = var.NET_CIDR_BLOCK
  enable_dns_hostnames = true
  enable_dns_support =  true

  tags = {
    Name = "default"
  }
}

resource "aws_internet_gateway" "k8s_eks_gateway" {
  vpc_id = aws_vpc.k8s_eks_vpc.id
  tags = {
    Name = "default"
  }
}

resource "aws_route_table" "k8s_eks_route" {
  vpc_id = aws_vpc.k8s_eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_eks_gateway.id
  }

  tags = {
    Name = "default"
  }
}

resource "aws_subnet" "k8s_eks_subnet_1" {
  vpc_id = aws_vpc.k8s_eks_vpc.id
  cidr_block = var.SUBNET_CIDR_BLOCK_01
  availability_zone = var.ZONE_SUBNET_01
  map_public_ip_on_launch = true

  depends_on = [
    aws_internet_gateway.k8s_eks_gateway
  ]
}

resource "aws_subnet" "k8s_eks_subnet_2" {
  vpc_id = aws_vpc.k8s_eks_vpc.id
  cidr_block = var.SUBNET_CIDR_BLOCK_02
  availability_zone = var.ZONE_SUBNET_02
  map_public_ip_on_launch = true

  depends_on = [
    aws_internet_gateway.k8s_eks_gateway
  ]
}

resource "aws_route_table_association" "k8s_eks_subnet_1_association" {
  subnet_id      = aws_subnet.k8s_eks_subnet_1.id
  route_table_id = aws_route_table.k8s_eks_route.id
}

resource "aws_route_table_association" "k8s_eks_subnet_2_association" {
  subnet_id      = aws_subnet.k8s_eks_subnet_2.id
  route_table_id = aws_route_table.k8s_eks_route.id
}
