# resource "aws_ecr_repository" "ad-service-ecr" {
#  name                               = "${var.service_name}-ecr"
#  image_tag_mutability               = "MUTABLE"

#  image_scanning_configuration {
#     scan_on_push = true
#   }
# }

module "aws-vpc" {
  source                              = "./modules/aws-vpc"
  vpc_cidr_block                      = "${var.vpc_cidr_block}"
  public_subnet_cidr_blocks           = ["${cidrsubnet(var.vpc_cidr_block, 8, 0)}", "${cidrsubnet(var.vpc_cidr_block, 8, 1)}"]
}

module "aws-alb" {
  source                              = "./modules/aws-alb"
  http_port                           = "${var.http_port}"
  ingress_cidr_blocks                 = "${var.ingress_cidr_blocks}"
  service_name                        = "${var.service_name}"
  subnets                             = "${module.aws-vpc.public_subnets_ids}"
  target_group_port                   = "${var.target_group_port}"
  target_type                         = "${var.target_type}"
  vpc_id                              = "${module.aws-vpc.vpc_id}"  
}

module "aws-ecs-fargate" {
      source                          = "./modules/aws-ecs-fargate"
      container_port                  = "${var.container_port}"
      load_balancer_security_group_id = "${module.aws-alb.load_balancer_security_group_id}"
      load_balancer_target_group_arn  = "${module.aws-alb.load_balancer_target_group_arn}"
      service_name                    = "${var.service_name}"
      subnets                         = "${module.aws-vpc.public_subnets_ids}"
      task_definition_file            = "${file("task-definitions-service.json")}"
      vpc_id                          = "${module.aws-vpc.vpc_id}"
      ecs_depends_on                  = "${module.aws-alb.load_balancer_https_listener}"
  }

resource "aws_cloudwatch_log_group" "default" {
      name                            = "/ecs/${var.service_name}"
      retention_in_days               = "${var.log_retention}"
}

module "aws-ecs-fargate-autoscaling" {
      source                          = "./modules/aws-ecs-fargate-autoscaling"
      interval                        = "${var.alarm_interval}"
      metric                          = "${var.alarm_metric}"
      statistic                       = "${var.alarm_statistic}"
      threshold_high                  = "${var.alarm_threshold_high}"
      threshold_low                   = "${var.alarm_threshold_low}"
      cooldown                        = "${var.autoscaling_cooldown}"
      min_capacity                    = "${var.autoscaling_min_capacity}"
      max_capacity                    = "${var.autoscaling_max_capacity}"
      ecs_cluster_name                = "${module.aws-ecs-fargate.ecs_cluster_name}"
      ecs_service_name                = "${module.aws-ecs-fargate.ecs_service_name}"
      service_name                    = "${var.service_name}"
      scaling_adjustment_up           = "${var.scaling_adjustment_up}"
      scaling_adjustment_down         = "${var.scaling_adjustment_down}"
  }