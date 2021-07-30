output "subnet_ids" {
  value = tolist(aws_subnet.subnets.*.id)
}

output "vpc_id" {
  value = aws_vpc.jenkins_vpc.id
}

output "sg_id" {
  value = aws_security_group.jenkins_sg.id
}