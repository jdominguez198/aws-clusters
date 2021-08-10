data "aws_globalaccelerator_accelerator" "ga_static_ip" {
  name = var.GA_NAME
}

data "aws_lb" "aws_lb_ingress" {
  tags = {
    "kubernetes.io/ingress-name" = "alb-ingress"
    "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}" = "owned"
  }

  depends_on = [
    kubernetes_ingress.alb-ingress
  ]
}

resource "aws_globalaccelerator_listener" "ga_listener" {
  accelerator_arn = data.aws_globalaccelerator_accelerator.ga_static_ip.id
  client_affinity = "SOURCE_IP"
  protocol        = "TCP"

  port_range {
    from_port = 443
    to_port   = 443
  }

  depends_on = [
    kubernetes_ingress.alb-ingress,
    data.aws_lb.aws_lb_ingress
  ]
}

resource "aws_globalaccelerator_endpoint_group" "alb_static_ip" {
  listener_arn = aws_globalaccelerator_listener.ga_listener.id

  endpoint_configuration {
    endpoint_id = data.aws_lb.aws_lb_ingress.id
    weight = 100
    client_ip_preservation_enabled = true
  }

  depends_on = [
    kubernetes_ingress.alb-ingress,
    aws_globalaccelerator_listener.ga_listener,
    data.aws_lb.aws_lb_ingress
  ]
}
