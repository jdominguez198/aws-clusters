
resource "kubernetes_service_account" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_iam-assumable-role-with-oidc.this_iam_role_arn
    }

    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io",
      k8s-app = "cluster-autoscaler"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_autoscaler
  ]
}

resource "kubernetes_cluster_role" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io",
      k8s-app = "cluster-autoscaler"
    }
  }

  rule {
    api_groups = [""]
    resources = ["events", "endpoints"]
    verbs = ["create", "patch"]
  }

  rule {
    api_groups = [""]
    resources = ["pods/eviction"]
    verbs = ["create"]
  }

  rule {
    api_groups = [""]
    resources = ["pods/status"]
    verbs = ["update"]
  }

  rule {
    api_groups = [""]
    resources = ["endpoints"]
    resource_names = ["cluster-autoscaler"]
    verbs = ["get", "update"]
  }

  rule {
    api_groups = [""]
    resources = ["nodes"]
    verbs = ["watch", "list", "get", "update"]
  }

  rule {
    api_groups = [""]
    resources = ["pods", "services", "replicationcontrollers", "persistentvolumeclaims", "persistentvolumes"]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["extensions"]
    resources = ["replicasets", "daemonsets"]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["policy"]
    resources = ["poddisruptionbudgets"]
    verbs = ["watch", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources = ["statefulsets", "replicasets", "daemonsets"]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources = ["storageclasses", "csinodes"]
    verbs = ["watch", "list", "get"]
  }

  rule {
    api_groups = ["batch", "extensions"]
    resources = ["jobs"]
    verbs = ["get", "list", "watch", "patch"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources = ["leases"]
    verbs = ["create"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resource_names = ["cluster-autoscaler"]
    resources = ["leases"]
    verbs = ["get", "update"]
  }
}

resource "kubernetes_role" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler"
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io",
      k8s-app = "cluster-autoscaler"
    }
  }

  rule {
    api_groups = [""]
    resources = ["configmaps"]
    verbs = ["create","list","watch"]
  }

  rule {
    api_groups = [""]
    resources = ["configmaps"]
    resource_names = ["cluster-autoscaler-status", "cluster-autoscaler-priority-expander"]
    verbs = ["delete", "get", "update", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io",
      k8s-app = "cluster-autoscaler"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.cluster_autoscaler.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.cluster_autoscaler.metadata.0.name
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
  }
}

resource "kubernetes_role_binding" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler"
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io",
      k8s-app = "cluster-autoscaler"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "Role"
    name = kubernetes_role.cluster_autoscaler.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.cluster_autoscaler.metadata.0.name
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
  }
}

resource "kubernetes_deployment" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "cluster-autoscaler"
      "app" = "cluster-autoscaler"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "cluster-autoscaler"
        "app" = "cluster-autoscaler"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "cluster-autoscaler"
          "app" = "cluster-autoscaler"
        }
        annotations = {
          "prometheus.io/scrape" = true
          "prometheus.io/port" = 8085
        }
      }

      spec {
        service_account_name = kubernetes_service_account.cluster_autoscaler.metadata.0.name
        priority_class_name = null

        container {
          image = "k8s.gcr.io/autoscaling/cluster-autoscaler:v1.22.0"
          name = "cluster-autoscaler"

          resources {
            limits =  {
              cpu = "100m"
              memory = "600Mi"
            }
            requests = {
              cpu = "100m"
              memory = "600Mi"
            }
          }

          command = [
            "./cluster-autoscaler",
            "--v=4",
            "--stderrthreshold=info",
            "--cloud-provider=aws",
            "--skip-nodes-with-local-storage=false",
            "--expander=least-waste",
            "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${var.EKS_CLUSTER_NAME}",
            "--balance-similar-node-groups",
            "--skip-nodes-with-system-pods=false",
          ]

          volume_mount {
            name = "ssl-certs"
            mount_path = "/etc/ssl/certs/ca-certificates.crt"
            read_only = true
          }

          volume_mount { # hack for automountServiceAccountToken
            name = kubernetes_service_account.cluster_autoscaler.default_secret_name
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            read_only = true
          }

          image_pull_policy = "Always"
        }

        volume {
          name = "ssl-certs"
          host_path {
            path = "/etc/ssl/certs/ca-bundle.crt"
          }
        }

        volume { # hack for automountServiceAccountToken
          name = kubernetes_service_account.cluster_autoscaler.default_secret_name
          secret {
            secret_name = kubernetes_service_account.cluster_autoscaler.default_secret_name
          }
        }
      }
    }
  }

  depends_on = [
    module.eks.node_groups
  ]
}
