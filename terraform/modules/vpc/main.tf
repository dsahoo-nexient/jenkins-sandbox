
locals {
  subnet_cidrs = ["10.1.3.0/24", "10.1.1.0/24", "10.1.2.0/24"]
  azs = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  cidr_all = "0.0.0.0/0"
}

resource "aws_vpc" "jenkins_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    "Name": "Jenkins"
  }
}

resource "aws_subnet" "subnets" {
  count = length(local.subnet_cidrs)
  cidr_block = element(local.subnet_cidrs, count.index)
  vpc_id = aws_vpc.jenkins_vpc.id
  map_public_ip_on_launch = true
  availability_zone = element(local.azs, count.index)
}

resource "aws_internet_gateway" "igt" {
  vpc_id = aws_vpc.jenkins_vpc.id
}

resource "aws_route_table" "external_route" {
  vpc_id = aws_vpc.jenkins_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igt.id
  }
}

resource "aws_route_table_association" route_subnets {
  count = length(local.subnet_cidrs)
  route_table_id = aws_route_table.external_route.id
  subnet_id = element(aws_subnet.subnets.*.id, count.index )
}

resource "aws_security_group" "jenkins_sg" {
  vpc_id = aws_vpc.jenkins_vpc.id
  name = "jenkins_sg"

}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [local.cidr_all]
  security_group_id = aws_security_group.jenkins_sg.id
}

resource "aws_security_group_rule" "jenkins_slave" {
  type              = "ingress"
  from_port         = 50000
  to_port           = 50000
  protocol          = "tcp"
  cidr_blocks       = [local.cidr_all]
  security_group_id = aws_security_group.jenkins_sg.id
}

resource "aws_security_group_rule" "http_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [local.cidr_all]
  security_group_id = aws_security_group.jenkins_sg.id
}

// Very imp to add the egress rule
resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_blocks = [local.cidr_all]
}
