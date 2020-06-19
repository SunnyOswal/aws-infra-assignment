variable "container_port" {
  description = "The port on the container to associate with the load balancer."
}

variable "load_balancer_security_group_id" {
  description = "Id of Load balancer security group."
}

variable "service_name" {
  description = "Service name . This will be used as prefix for all service components resources names."
}

variable "subnets" {
  description = "Service name . This will be used as prefix for all service components resources names."
}

variable "load_balancer_target_group_arn" {
  description = "ARN for Load balancer target group"
}

variable "task_definition_file" {
  description = "Container definition used in task definiton resource configuration."
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "ecs_depends_on" {
  default = "null"
  description = "Required as modules does not support depends_on"

}