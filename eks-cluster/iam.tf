
module "iam_iam-assumable-role-with-oidc" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version               = "3.6.0"
  aws_account_id        = data.aws_caller_identity.current.account_id
  role_name             = "${var.PREFIX}-${local.openid_connect_role_name}"
  create_role           = true
  force_detach_policies = true
  provider_url          = module.eks.cluster_oidc_issuer_url
  role_policy_arns      = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}

resource "aws_iam_policy" "load-balancer-policy" {
  name = "${var.PREFIX}-${local.load_balancer_role_name}"
  path = "/"
  policy = file("./iam/iam-load-balancer-policy.json")
}

resource "aws_iam_role_policy_attachment" "AmazonLoadBalancer" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.PREFIX}-${local.load_balancer_role_name}"
  role = module.eks.cluster_iam_role_name
}

resource "aws_iam_role_policy_attachment" "alb-ingress-controller-role-policy" {
  policy_arn = aws_iam_policy.load-balancer-policy.arn
  role = module.iam_iam-assumable-role-with-oidc.this_iam_role_name
}

resource "aws_iam_policy" "cluster_autoscaler" {
  count = 1
  name = "${var.PREFIX}-${local.cluster_autoscaler_role_name}"
  path = "/"
  policy = file("./iam/iam-autoscaler-policy.json")
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  count = 1

  role = "${var.PREFIX}-${local.openid_connect_role_name}"
  policy_arn = aws_iam_policy.cluster_autoscaler.0.arn

  depends_on = [
    module.iam_iam-assumable-role-with-oidc.this_iam_role_name,
    aws_iam_policy.cluster_autoscaler
  ]
}
