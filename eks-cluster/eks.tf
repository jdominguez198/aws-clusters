resource "aws_eks_cluster" "aws_eks" {
  name = "k8s_aws"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = [ aws_subnet.k8s_eks_subnet_1.id, aws_subnet.k8s_eks_subnet_2.id ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name = "k8s_aws_test"
  }
}

resource "aws_eks_node_group" "node" {
  cluster_name = aws_eks_cluster.aws_eks.name
  node_group_name = "k8s_aws_nodes"
  node_role_arn = aws_iam_role.eks_nodes.arn
  subnet_ids = [ aws_subnet.k8s_eks_subnet_1.id, aws_subnet.k8s_eks_subnet_2.id ]

  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = 3
    max_size = 3
    min_size = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
