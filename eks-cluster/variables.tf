data "aws_vpc" "k8s_aws_vpc_default" {
  filter {
    name = "tag:Name"
    values = ["default"]
  }
}

data "aws_subnet_ids" "k8s_aws_subnet_ids" {
  vpc_id = data.aws_vpc.k8s_aws_vpc_default.id
}

data "aws_subnet" "k8s_aws_subnet" {
  count = length(data.aws_subnet_ids.k8s_aws_subnet_ids.ids)
  id = tolist(data.aws_subnet_ids.k8s_aws_subnet_ids.ids)[count.index]
}

output "subnet_cidr_blocks" {
  value = data.aws_subnet.k8s_aws_subnet.*.id
}
