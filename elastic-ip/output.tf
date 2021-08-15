output "eip_01_id" {
  value = aws_eip.k8s_aws_eip_01.id
}

output "eip_01_ip" {
  value = aws_eip.k8s_aws_eip_01.public_ip
}

output "eip_02_id" {
  value = aws_eip.k8s_aws_eip_02.id
}

output "eip_02_ip" {
  value = aws_eip.k8s_aws_eip_02.public_ip
}
