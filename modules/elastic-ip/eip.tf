resource "aws_eip" "aws_eip_01" {
  tags = {
    Name = "${var.name}-01"
  }
}

resource "aws_eip" "aws_eip_02" {
  tags = {
    Name = "${var.name}-02"
  }
}
