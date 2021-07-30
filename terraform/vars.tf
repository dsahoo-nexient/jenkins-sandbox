variable "aws_access_key" {
  type = string
  //sensitive = true
}

variable "aws_secret_key" {
  type = string
  //sensitive = true
}

variable "aws_account_number" {
  type = string
}

variable "aws_region" {
  type = string
  default = "us-east-2"
}

variable "ecs_cluster_name" {
  type = string
  default = "jenkins_cluster_tf"
}

variable "route53_hosted_zone_id" {
  type = string
  default = "Z05913371GYASKC3LWL8U"
}

variable "docker_image_ecr" {
  type = string
  default = "753492139907.dkr.ecr.us-east-2.amazonaws.com/jenkins-sandbox:1.1.0"
}