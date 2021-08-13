output "ga_dns_name" {
  description = "Global Accelerator DNS name"
  value = aws_globalaccelerator_accelerator.ga_instance.dns_name
}

output "ga_ip_sets" {
  description = "Global Accelerator IP sets"
  value = aws_globalaccelerator_accelerator.ga_instance.ip_sets
}
