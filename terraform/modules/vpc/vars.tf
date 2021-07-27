variable "aws_access_key" {
  type = string
  //sensitive = true
}

variable "aws_secret_key" {
  type = string
  //sensitive = true
}

variable "aws_region" {
  type = string
  default = "us-east-2"
}

variable "ecs_cluster_name" {
  type = string
  default = "jenkins_cluster_tf"
}