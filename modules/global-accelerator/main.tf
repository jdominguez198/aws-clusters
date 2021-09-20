resource "aws_globalaccelerator_accelerator" "ga_instance" {
  name = var.name
  ip_address_type = "IPV4"
  enabled = true
}
