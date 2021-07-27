output "subnet_ids" {
  value = tolist(aws_subnet.subnets.*.id)
}

output "vpc_id" {
  value = aws_vpc.jenkins_vpc.id
}