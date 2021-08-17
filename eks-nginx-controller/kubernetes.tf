data "aws_eks_cluster" "cluster" {
  name = var.EKS_CLUSTER_NAME
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.EKS_CLUSTER_NAME
}

provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.cluster.token
}

resource "kubernetes_namespace" "nginx-controller-namespace" {
  metadata {
    name = local.service_account_name
    labels = local.common_labels
  }
}