resource "aws_acm_certificate" "acm_tls" {
  private_key = file("./certificates/ssl_key")
  certificate_body = file("./certificates/ssl_body")
  certificate_chain = file("./certificates/ssl_chain")
}
