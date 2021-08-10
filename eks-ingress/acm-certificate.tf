provider "aws" {
  region = var.ZONE
}

resource "aws_acm_certificate" "alb_ingress_certificate" {
  private_key = file("./certificates/ssl_key")
  certificate_body = file("./certificates/ssl_body")
  certificate_chain = file("./certificates/ssl_chain")
}
