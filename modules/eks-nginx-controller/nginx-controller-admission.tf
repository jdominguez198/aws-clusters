resource "kubernetes_service_account" "nginx-controller-service-account-admission" {
  metadata {
    name = "ingress-nginx-admission"
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    labels = merge(
    local.common_labels,
    local.component_admission_webhook_labels
    )

    annotations = {
      "helm.sh/hook" = "pre-install,pre-upgrade,post-install,post-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
    }
  }
}

resource "kubernetes_cluster_role" "nginx-controller-cluster-role-admission" {
  metadata {
    name = "ingress-nginx-admission"

    labels = merge(
    local.common_labels,
    local.component_admission_webhook_labels
    )

    annotations = {
      "helm.sh/hook" = "pre-install,pre-upgrade,post-install,post-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
    }
  }

  rule {
    api_groups = ["admissionregistration.k8s.io"]
    resources = ["validatingwebhookconfigurations"]
    verbs = ["get", "update"]
  }
}

resource "kubernetes_cluster_role_binding" "nginx-controller-cluster-role-binding-admission" {
  metadata {
    name = "ingress-nginx-admission"

    labels = merge(
    local.common_labels,
    local.component_admission_webhook_labels
    )

    annotations = {
      "helm.sh/hook" = "pre-install,pre-upgrade,post-install,post-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.nginx-controller-cluster-role-admission.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.nginx-controller-service-account-admission.metadata.0.name
    namespace = kubernetes_service_account.nginx-controller-service-account-admission.metadata.0.namespace
  }
}

resource "kubernetes_role" "nginx-controller-role-admission" {
  metadata {
    name = "ingress-nginx-admission"
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    labels = merge(
    local.common_labels,
    local.component_admission_webhook_labels
    )

    annotations = {
      "helm.sh/hook" = "pre-install,pre-upgrade,post-install,post-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
    }
  }

  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["get", "create"]
  }
}

resource "kubernetes_role_binding" "nginx-controller-role-binding-admission" {
  metadata {
    name = "ingress-nginx-admission"
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    labels = merge(
    local.common_labels,
    local.component_admission_webhook_labels
    )

    annotations = {
      "helm.sh/hook" = "pre-install,pre-upgrade,post-install,post-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "Role"
    name = kubernetes_role.nginx-controller-role-admission.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.nginx-controller-service-account-admission.metadata.0.name
    namespace = kubernetes_service_account.nginx-controller-service-account-admission.metadata.0.namespace
  }
}

resource "kubernetes_service" "nginx-controller-service-admission" {
  metadata {
    name = "ingress-nginx-controller-admission"
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    labels = merge(
    local.common_labels,
    local.component_controller_labels
    )
  }

  spec {
    type = "ClusterIP"

    selector = merge(
    local.common_labels,
    local.component_controller_labels
    )

    port {
      name = "https-webhook"
      port = 443
      target_port = "webhook"
    }
  }
}

resource "kubernetes_validating_webhook_configuration" "nginx-controller-admission-webhook" {
  metadata {
    name = "ingress-nginx-admission"

    labels = merge(
    local.common_labels,
    local.component_admission_webhook_labels
    )
  }

  webhook {
    name = "validate.nginx.ingress.kubernetes.io"
    admission_review_versions = ["v1", "v1beta1"]
    side_effects = "None"
    failure_policy = "Ignore"
    match_policy = "Equivalent"

    client_config {
      service {
        namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name
        name = kubernetes_service.nginx-controller-service-admission.metadata.0.name
        path = "/networking/v1beta1/ingresses"
      }
    }

    rule {
      api_groups = ["networking.k8s.io"]
      api_versions = ["v1beta1"]
      operations = ["CREATE", "UPDATE"]
      resources = ["ingresses"]
    }
  }

  depends_on = [
    kubernetes_service.nginx-controller-service-admission
  ]
}

resource "kubernetes_job" "nginx-controller-job-create" {
  metadata {
    name = "ingress-nginx-admission-create"
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    labels = merge(
    local.common_labels,
    local.component_admission_webhook_labels
    )

    annotations = {
      "helm.sh/hook" = "pre-install,pre-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
    }
  }

  spec {
    template {
      metadata {
        name = "ingress-nginx-admission-create"

        labels = merge(
        local.common_labels,
        local.component_admission_webhook_labels
        )
      }

      spec {
        container {
          name = "create"
          image = "docker.io/jettech/kube-webhook-certgen:v1.5.1"
          image_pull_policy = "IfNotPresent"
          args = [
            "create",
            "--host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.${kubernetes_namespace.nginx-controller-namespace.metadata.0.name}.svc",
            "--namespace=${kubernetes_namespace.nginx-controller-namespace.metadata.0.name}",
            "--secret-name=ingress-nginx-admission"
          ]
        }
        restart_policy = "OnFailure"
        service_account_name = kubernetes_service_account.nginx-controller-service-account-admission.metadata.0.name

        security_context {
          run_as_non_root = true
          run_as_user = 2000
        }
      }
    }
  }

  wait_for_completion = true

  timeouts {
    create = "120s"
  }

  depends_on = [
    kubernetes_validating_webhook_configuration.nginx-controller-admission-webhook
  ]
}

resource "kubernetes_job" "nginx-controller-job-patch" {
  metadata {
    name = "ingress-nginx-admission-patch"
    namespace = kubernetes_namespace.nginx-controller-namespace.metadata.0.name

    labels = merge(
    local.common_labels,
    local.component_admission_webhook_labels
    )

    annotations = {
      "helm.sh/hook" = "post-install,post-upgrade"
      "helm.sh/hook-delete-policy" = "before-hook-creation,hook-succeeded"
    }
  }

  spec {
    template {
      metadata {
        name = "ingress-nginx-admission-patch"

        labels = merge(
        local.common_labels,
        local.component_admission_webhook_labels
        )
      }

      spec {
        container {
          name = "patch"
          image = "docker.io/jettech/kube-webhook-certgen:v1.5.1"
          image_pull_policy = "IfNotPresent"
          args = [
            "patch",
            "--webhook-name=${kubernetes_validating_webhook_configuration.nginx-controller-admission-webhook.metadata.0.name}",
            "--namespace=${kubernetes_namespace.nginx-controller-namespace.metadata.0.name}",
            "--patch-mutating=false",
            "--secret-name=ingress-nginx-admission",
            "--patch-failure-policy=Fail"
          ]
        }
        restart_policy = "OnFailure"
        service_account_name = kubernetes_service_account.nginx-controller-service-account-admission.metadata.0.name

        security_context {
          run_as_non_root = true
          run_as_user = 2000
        }
      }
    }
  }

  wait_for_completion = true

  timeouts {
    create = "120s"
  }

  depends_on = [
    kubernetes_job.nginx-controller-job-create
  ]
}
