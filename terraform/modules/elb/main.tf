

resource "aws_lb" "jenkins_alb" {
  load_balancer_type = "application"
  internal = false
  name = "jenkins-alb-tf"
  subnets = tolist(var.subnet_ids)
  security_groups = [var.sg_id]
  tags = {
    "Terraform" = "True"
  }
}

resource "aws_alb_target_group" "jenkins_tg" {
  name = "jenkins-tg-tf"
  protocol = "HTTP"
  port = 8080
  target_type = "ip"
  vpc_id = var.vpc_id
  health_check {
    port = "8080"
    protocol = "HTTP"
  }
}

resource "aws_alb_listener" "jenkins-https-listener" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port = 443
  ssl_policy = "ELBSecurityPolicy-2016-08"
  protocol = "HTTPS"
  certificate_arn = var.certificate_arn
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.jenkins_tg.arn
  }
}