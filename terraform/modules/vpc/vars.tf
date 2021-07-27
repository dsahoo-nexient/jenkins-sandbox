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
