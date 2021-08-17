data "aws_eip" "eip-01" {
  tags = {
    Name = "${var.ELASTIC_IP_NAME}_01"
  }
}

data "aws_eip" "eip-02" {
  tags = {
    Name = "${var.ELASTIC_IP_NAME}_02"
  }
}
