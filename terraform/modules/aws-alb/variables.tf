variable "http_port" {
  description = "The HTTP port."
}

variable "ingress_cidr_blocks" {
  description = "List of Ingress CIDR blocks."
}

variable "subnets" {
  type        = "list"
  description = "Subnets for alb."
}
variable "service_name" {
  description = "Service name . This will be used as prefix for all service components resources names."
}
variable "target_group_port" {
  description = "The port on which targets receive traffic."
}

variable "target_type" {
  description = "The type of target that you must specify when registering targets with this target group. The possible values are instance or ip."
}

variable "vpc_id" {
  description = "The ID of the VPC"
}