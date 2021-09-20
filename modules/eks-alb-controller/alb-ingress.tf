resource "kubernetes_ingress" "alb-ingress" {
  metadata {
    name = "alb-ingress"

    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/inbound-cidrs" = "0.0.0.0/0"
      "alb.ingress.kubernetes.io/certificate-arn" = aws_acm_certificate.alb_ingress_certificate.id
    }

    labels = {
      "app.kubernetes.io/name" = "alb-ingress"
    }
  }

  spec {
    backend {
      service_name = var.eks_ingress_backend_name
      service_port = var.eks_ingress_backend_port
    }
  }

  depends_on = [
    aws_acm_certificate.alb_ingress_certificate,
    data.aws_eks_cluster.cluster
  ]
}
