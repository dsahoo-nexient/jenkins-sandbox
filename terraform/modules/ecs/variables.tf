variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  type = string
  description = "used in the ecs module to be passed to jenkins container"
}

variable "aws_account_number" {
  type = string
  description = "used in the ecs module to be passed to jenkins container"
}

variable "app_name" {
  type = string
  default = "jenkins"
}

variable "docker_image" {
  type = string
  default = "753492139907.dkr.ecr.us-east-2.amazonaws.com/jenkins-sandbox:1.1.0"
}

variable "execution_role_arn" {
  type = string
  default = "arn:aws:iam::753492139907:role/ecsTaskExecutionRole"
}

variable "tf_secret_arn" {
  type = string
}

variable "subnet_ids" {}

variable "sg_id" {}

variable "alb_name" {}

variable "tg_arn" {}