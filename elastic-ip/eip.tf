resource "aws_eip" "k8s_aws_eip_01" {
  tags = {
    Name = "${var.STATIC_IP_NAME}-01"
  }
}

resource "aws_eip" "k8s_aws_eip_02" {
  tags = {
    Name = "${var.STATIC_IP_NAME}-02"
  }
}
