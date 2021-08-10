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
      service_name = var.INGRESS_BACKEND_SERVICE_NAME
      service_port = var.INGRESS_BACKEND_SERVICE_PORT
    }
  }

  depends_on = [
    aws_acm_certificate.alb_ingress_certificate,
    data.aws_eks_cluster.cluster
  ]
}
