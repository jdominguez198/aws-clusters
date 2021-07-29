output "eks_cluster_endpoint" {
  value = aws_eks_cluster.aws_eks.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.aws_eks.certificate_authority
}

output "subnet_cidr_blocks" {
  value = [ aws_subnet.k8s_eks_subnet_1.id, aws_subnet.k8s_eks_subnet_2.id ]
}
