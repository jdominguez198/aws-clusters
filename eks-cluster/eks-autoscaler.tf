
resource "kubernetes_service_account" "cluster_autoscaler" {
  metadata {
    name = "eks-cluster-autoscaler"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:role/${local.openid_connect_role_name}"
    }

    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io",
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_autoscaler
  ]
}

resource "kubernetes_cluster_role" "cluster_autoscaler" {
  metadata {
    name = "eks-cluster-autoscaler"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io",
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
    name = "eks-cluster-autoscaler"
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io",
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
    name = "eks-cluster-autoscaler"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io",
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
    name = "eks-cluster-autoscaler"
    namespace = kubernetes_service_account.cluster_autoscaler.metadata.0.namespace
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io",
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
    name = "eks-cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      k8s-addon = "cluster-autoscaler.addons.k8s.io",
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "alb-ingress-controller"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "alb-ingress-controller"
          k8s-addon = "cluster-autoscaler.addons.k8s.io",
        }
        annotations = {}
      }

      spec {
        service_account_name = kubernetes_service_account.cluster_autoscaler.metadata.0.name

        priority_class_name = null

        container {
          image = "k8s.gcr.io/autoscaling/cluster-autoscaler:v1.18.3"
          name = "cluster-autoscaler"

          resources{
            limits =  {
              cpu = "100m"
              memory = "512Mi"
            }
            requests = {
              cpu = "100m"
              memory = "512Mi"
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

        node_selector = {}
      }
    }
  }
}
