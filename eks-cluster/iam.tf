
module "iam_iam-assumable-role-with-oidc" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version               = "3.6.0"
  aws_account_id        = var.AWS_ACCOUNT_ID
  role_name             = local.openid_connect_role_name
  create_role           = true
  force_detach_policies = true
  provider_url          = module.eks.cluster_oidc_issuer_url
  role_policy_arns      = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}

resource "aws_iam_policy" "load-balancer-policy" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  path = "/"
  description = "AWS LoadBalancer Controller IAM Policy"
  policy = file("./iam/iam-load-balancer-policy.json")
}

resource "aws_iam_role_policy_attachment" "AmazonLoadBalancer" {
  policy_arn = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy"
  role = module.eks.cluster_iam_role_name
}

resource "aws_iam_role_policy_attachment" "alb-ingress-controller-role-policy" {
  policy_arn = aws_iam_policy.load-balancer-policy.arn
  role = module.iam_iam-assumable-role-with-oidc.this_iam_role_name
}

resource "aws_iam_policy" "cluster_autoscaler" {
  count = 1

  name = "KubernetesClusterAutoscaler"
  path = "/"
  description = "Allows access to resources needed to run kubernetes cluster autoscaler."

  policy = file("./iam/iam-autoscaler-policy.json")
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  count = 1

  role = local.openid_connect_role_name
  policy_arn = aws_iam_policy.cluster_autoscaler.0.arn

  depends_on = [
    module.iam_iam-assumable-role-with-oidc.this_iam_role_name,
    aws_iam_policy.cluster_autoscaler
  ]
}
