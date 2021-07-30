
variable "aws_account_number" {
  type = string
}
variable "certificate_arn" {
  type = string
  default = "arn:aws:acm:us-east-2:753492139907:certificate/f1bca712-1a77-4dd8-9144-6cede56b6863"
}

variable "vpc_id" {}

variable subnet_ids {}
variable "sg_id" {}
variable "hosted_zone_id" {}