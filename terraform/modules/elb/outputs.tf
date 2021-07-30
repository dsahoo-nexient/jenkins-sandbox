output "alb_name" {
  value = aws_lb.jenkins_alb.name
}

output "tg_arn" {
  value = aws_alb_target_group.jenkins_tg.arn
}

output "alb_dns" {
  value = aws_lb.jenkins_alb.dns_name
}