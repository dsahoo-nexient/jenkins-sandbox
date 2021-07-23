provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

locals {
  subnet_cidrs = ["10.1.3.0/24", "10.1.1.0/24", "10.1.2.0/24"]
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
  //availability_zone = "${var.aws_region}a"
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