data "aws_eip" "eip-01" {
  tags = {
    Name = "${var.eip_name}-01"
  }
}

data "aws_eip" "eip-02" {
  tags = {
    Name = "${var.eip_name}-02"
  }
}
