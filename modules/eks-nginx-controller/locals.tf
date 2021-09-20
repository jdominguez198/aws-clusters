locals {
  // nginx-controller related
  base_name = "ingress-nginx"
  service_account_name = "ingress-nginx"

  common_labels = {
    "app.kubernetes.io/name" = "ingress-nginx"
    "app.kubernetes.io/instance" = "ingress-nginx"
  }

  component_controller_labels = {
    "app.kubernetes.io/component" = "controller"
  }

  component_admission_webhook_labels = {
    "app.kubernetes.io/component" = "admission-webhook"
  }
}
