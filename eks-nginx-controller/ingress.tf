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
      service_name = var.INGRESS_BACKEND_SERVICE_NAME
      service_port = var.INGRESS_BACKEND_SERVICE_PORT
    }
  }

  wait_for_load_balancer = true
}
