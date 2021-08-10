resource "kubernetes_service_account" "aws-load-balancer-controller" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:role/${local.openid_connect_role_name}"
    }

    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
  }

  automount_service_account_token = true

  depends_on = [
    module.iam_iam-assumable-role-with-oidc.this_iam_role_name
  ]
}

resource "kubernetes_cluster_role" "alb-ingress-controller" {
  metadata {
    name = "alb-ingress-controller"

    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
  }

  rule {
    api_groups = ["", "extensions"]
    resources = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
    verbs = ["create", "get", "list", "update", "watch", "patch"]
  }

  rule {
    api_groups = ["", "extensions"]
    resources = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "alb-ingress-controller" {
  metadata {
    name = "alb-ingress-controller"

    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.alb-ingress-controller.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.aws-load-balancer-controller.metadata.0.name
    namespace = kubernetes_service_account.aws-load-balancer-controller.metadata.0.namespace
  }
}

resource "kubernetes_deployment" "alb-ingress-controller" {
  metadata {
    name = "alb-ingress-controller"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/name" = "alb-ingress-controller"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "alb-ingress-controller"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "alb-ingress-controller"
        }
      }

      spec {
        container {
          name = "alb-ingress-controller"
          image = "docker.io/amazon/aws-alb-ingress-controller:v1.1.8"
          args = [
            "--ingress-class=alb",
            "--cluster-name=k8s_aws",
            "--aws-vpc-id=${module.vpc.vpc_id}",
            "--aws-region=${var.ZONE}"
          ]

          volume_mount { # hack for automountServiceAccountToken
            name = kubernetes_service_account.aws-load-balancer-controller.default_secret_name
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            read_only = true
          }

          image_pull_policy = "Always"
        }

        volume { # hack for automountServiceAccountToken
          name = kubernetes_service_account.aws-load-balancer-controller.default_secret_name
          secret {
            secret_name = kubernetes_service_account.aws-load-balancer-controller.default_secret_name
          }
        }

        automount_service_account_token = true

        service_account_name = kubernetes_service_account.aws-load-balancer-controller.metadata.0.name
      }
    }
  }

  depends_on = [
    aws_iam_policy.load-balancer-policy,
    aws_iam_role_policy_attachment.alb-ingress-controller-role-policy,
    module.eks.node_groups
  ]
}
