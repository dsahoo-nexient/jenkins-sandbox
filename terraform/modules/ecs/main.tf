resource "aws_ecs_cluster" "jenkins_ecs_cluster" {
  name = "${var.app_name}-tf-ecs-cluster"
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

}

resource "aws_ecs_task_definition" "jenkins_master" {
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 1024
  memory = 2048
  execution_role_arn = var.execution_role_arn
  task_role_arn = var.execution_role_arn
  container_definitions = jsonencode([
  {
      name      = "${var.app_name}-master"
      image     = var.docker_image
      //cpu       = 1024
      //memory    = 2048
      essential = true
//    secrets = [
//      { name: "AWS_ACCESS_KEY", valueFrom: "${var.tf_secret_arn}:aws_access_key"},
//      { name: "AWS_SECRET_KEY", valueFrom: "${var.tf_secret_arn}:aws_secret_key"},
//      { name: "AWS_REGION", valueFrom: var.aws_region},
//      { name: "AWS_ACCOUNT_NUMBER", valueFrom: var.aws_account_number}
//    ]
      environment = [
        {name: "AWS_REGION", value: var.aws_region},
        {name: "AWS_ACCOUNT_NUMBER", value: var.aws_account_number},
        {name: "AWS_ACCESS_KEY", value: var.aws_access_key},
        {name: "AWS_SECRET_KEY", value: var.aws_secret_key},
      ]
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        },
        {
          containerPort = 50000
          hostPort = 50000
        }
      ]
    }
  ])
  family = "jenkins-master-tf"
}

resource "aws_ecs_service" "jenkins_service" {
  count = 1
  name = "jenkins-service-tf"
  cluster = aws_ecs_cluster.jenkins_ecs_cluster.arn
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100
  desired_count = 1
  enable_ecs_managed_tags = true
  force_new_deployment = true
  launch_type = "FARGATE"
  network_configuration {
    subnets = var.subnet_ids
    security_groups = [var.sg_id]
    assign_public_ip = true
  }
  scheduling_strategy = "REPLICA"
  tags = {
    "Terraform": "True"
  }
  task_definition = aws_ecs_task_definition.jenkins_master.arn
  load_balancer {
    container_name = "${var.app_name}-master"
    container_port = 8080
    //elb_name = var.alb_name
    target_group_arn = var.tg_arn
  }
}