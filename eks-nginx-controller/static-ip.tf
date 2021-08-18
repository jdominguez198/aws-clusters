data "aws_eip" "eip-01" {
  tags = {
    Name = "${var.ELASTIC_IP_NAME}-01"
  }
}

data "aws_eip" "eip-02" {
  tags = {
    Name = "${var.ELASTIC_IP_NAME}-02"
  }
}
