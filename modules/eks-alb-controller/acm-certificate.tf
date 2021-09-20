resource "aws_acm_certificate" "alb_ingress_certificate" {
  private_key = file(var.acm_ssl_key_path)
  certificate_body = file(var.acm_ssl_body_path)
  certificate_chain = file(var.acm_ssl_chain_path)
}
