resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "ingress"

    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = false
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = false
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    backend {
      service_name = var.eks_ingress_backend_name
      service_port = var.eks_ingress_backend_port
    }
  }

  wait_for_load_balancer = true
}
