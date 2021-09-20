resource "kubernetes_namespace" "nginx-controller-namespace" {
  metadata {
    name = local.service_account_name
    labels = local.common_labels
  }
}

resource "kubernetes_service_account" "nginx-controller-service-account" {
  metadata {
    name = var.eks_ingress_namespace
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    labels = merge(
      local.common_labels,
      local.component_controller_labels
    )
  }
}

resource "kubernetes_config_map" "nginx-controller-configmap" {
  metadata {
    name = "ingress-nginx-controller"
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    labels = merge(
      local.common_labels,
      local.component_controller_labels
    )
  }

  // Redirect from http to https "workaround"
  // https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.48.1/deploy/static/provider/baremetal/deploy.yaml
  data = {
    http-snippet = <<EOF
      server {
        listen 2443;
        return 308 https://$host$request_uri;
      }
    EOF
    use-forwarded-headers = true
  }
}

resource "kubernetes_cluster_role" "nginx-controller-cluster-role" {
  metadata {
    name = "ingress-nginx"

    labels = local.common_labels
  }

  rule {
    api_groups = [""]
    resources = ["configmaps", "endpoints", "nodes", "pods", "secrets"]
    verbs = ["list", "watch"]
  }

  rule {
    api_groups = [""]
    resources = ["nodes"]
    verbs = ["get"]
  }

  rule {
    api_groups = [""]
    resources = ["services"]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources = ["ingresses"]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources = ["ingresses/status"]
    verbs = ["update"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["ingressclasses"]
    verbs = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "nginx-controller-cluster-role-binding" {
  metadata {
    name = "ingress-nginx"

    labels = local.common_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.nginx-controller-cluster-role.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.nginx-controller-service-account.metadata.0.name
    namespace = kubernetes_service_account.nginx-controller-service-account.metadata.0.namespace
  }
}

resource "kubernetes_role" "nginx-controller-role" {
  metadata {
    name = "ingress-nginx"
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    labels = merge(
      local.common_labels,
      local.component_controller_labels
    )
  }

  rule {
    api_groups = [""]
    resources = ["namespaces"]
    verbs = ["get"]
  }

  rule {
    api_groups = [""]
    resources = ["configmaps", "pods", "secrets", "endpoints"]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources = ["services"]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources = ["ingresses"]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources = ["ingresses/status"]
    verbs = ["update"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["ingressclasses"]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources = ["configmaps"]
    resource_names = ["ingress-controller-leader-nginx"]
    verbs = ["get", "update"]
  }

  rule {
    api_groups = [""]
    resources = ["configmaps"]
    verbs = ["create"]
  }

  rule {
    api_groups = [""]
    resources = ["events"]
    verbs = ["create", "patch"]
  }
}

resource "kubernetes_role_binding" "nginx-controller-role-binding" {
  metadata {
    name = "ingress-nginx"
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    labels = merge(
      local.common_labels,
      local.component_controller_labels
    )
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "Role"
    name = kubernetes_role.nginx-controller-role.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.nginx-controller-service-account.metadata.0.name
    namespace = kubernetes_service_account.nginx-controller-service-account.metadata.0.namespace
  }
}

resource "kubernetes_service" "nginx-controller-service" {
  metadata {
    name = "ingress-nginx-controller"
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-backend-protocol" = "tcp"
      "service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout" = 60
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = true
      "service.beta.kubernetes.io/aws-load-balancer-ssl-cert" = aws_acm_certificate.alb_ingress_certificate.arn
      "service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy" = "ELBSecurityPolicy-TLS-1-2-2017-01"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-ports" = "https"
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-eip-allocations" = "${data.aws_eip.eip-01.id},${data.aws_eip.eip-02.id}"
    }

    labels = merge(
      local.common_labels,
      local.component_controller_labels
    )
  }

  spec {
    type = "LoadBalancer"
    external_traffic_policy = "Local"

    selector = merge(
      local.common_labels,
      local.component_controller_labels
    )

    port {
      name = "http"
      port = 80
      protocol = "TCP"
      target_port = "tohttps"
    }

    port {
      name = "https"
      port = 443
      protocol = "TCP"
      target_port = "http"
    }
  }
}

resource "kubernetes_deployment" "nginx-controller-deployment" {
  metadata {
    name = "ingress-nginx-controller"
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    labels = merge(
      local.common_labels,
      local.component_controller_labels
    )
  }

  spec {
    selector {
      match_labels = merge(
        local.common_labels,
        local.component_controller_labels
      )
    }

    revision_history_limit = 10
    min_ready_seconds = 0

    template {
      metadata {
        labels = merge(
          local.common_labels,
          local.component_controller_labels
        )
      }

      spec {
        dns_policy = "ClusterFirst"

        container {
          name = "controller"
          image = "k8s.gcr.io/ingress-nginx/controller:v0.48.1@sha256:e9fb216ace49dfa4a5983b183067e97496e7a8b307d2093f4278cd550c303899"
          image_pull_policy = "IfNotPresent"

          lifecycle {
            pre_stop {
              exec {
                command = [
                  "/wait-shutdown"
                ]
              }
            }
          }

          args = [
            "/nginx-ingress-controller",
            "--publish-service=${kubernetes_namespace.nginx-controller-namespace.metadata.0.name}/${kubernetes_service.nginx-controller-service.metadata.0.name}",
            "--election-id=ingress-controller-leader",
            "--ingress-class=nginx",
            "--configmap=${kubernetes_namespace.nginx-controller-namespace.metadata.0.name}/${kubernetes_config_map.nginx-controller-configmap.metadata.0.name}",
            "--validating-webhook=:8443",
            "--validating-webhook-certificate=/usr/local/certificates/cert",
            "--validating-webhook-key=/usr/local/certificates/key"
          ]

          security_context {
            capabilities {
              drop = ["ALL"]
              add = ["NET_BIND_SERVICE"]
            }
            run_as_user = 101
            allow_privilege_escalation = true
          }

          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "LD_PRELOAD"
            value = "/usr/local/lib/libmimalloc.so"
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = 10254
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds = 10
            timeout_seconds = 1
            success_threshold = 1
            failure_threshold = 3
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = 10254
              scheme = "HTTP"
            }
            initial_delay_seconds = 10
            period_seconds = 10
            timeout_seconds = 1
            success_threshold = 1
            failure_threshold = 3
          }

          port {
            name = "http"
            container_port = 80
            protocol = "TCP"
          }

          port {
            name = "https"
            container_port = 80
            protocol = "TCP"
          }

          port {
            name = "tohttps"
            container_port = 2443
            protocol = "TCP"
          }

          port {
            name = "webhook"
            container_port = 8443
            protocol = "TCP"
          }

          volume_mount {
            name = "webhook-cert"
            mount_path = "/usr/local/certificates/"
            read_only = true
          }

          resources {
            requests = {
              cpu = "100m"
              memory = "90Mi"
            }
          }
        }

        volume {
          name = "webhook-cert"
          secret {
            secret_name = "ingress-nginx-admission"
          }
        }

        termination_grace_period_seconds = 300
        automount_service_account_token = true
        service_account_name = kubernetes_service_account.nginx-controller-service-account.metadata.0.name
      }
    }
  }

  depends_on = [
    kubernetes_service.nginx-controller-service,
    kubernetes_validating_webhook_configuration.nginx-controller-admission-webhook
  ]
}
