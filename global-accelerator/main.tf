resource "aws_globalaccelerator_accelerator" "ga_instance" {
  name = var.GA_NAME
  ip_address_type = "IPV4"
  enabled = true
}
