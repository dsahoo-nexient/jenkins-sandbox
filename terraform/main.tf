provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

module "vpc_tf" {
  source = "./modules/vpc"
  aws_account_number = var.aws_account_number
}

module "alb_tf" {
  source = "./modules/elb"
  aws_account_number = var.aws_account_number
  vpc_id = module.vpc_tf.vpc_id
  subnet_ids = module.vpc_tf.subnet_ids
  sg_id = module.vpc_tf.sg_id
}

module "secrets" {
  source = "./modules/misc"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
}

module "ecs_tf" {
  source = "./modules/ecs"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  tf_secret_arn = module.secrets.secret_arn
  aws_account_number = var.aws_account_number
  aws_region = var.aws_region
  sg_id = module.vpc_tf.sg_id
  subnet_ids = module.vpc_tf.subnet_ids
  alb_name = module.alb_tf.alb_name
  tg_arn = module.alb_tf.tg_arn
}