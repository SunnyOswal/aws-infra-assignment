variable "container_port" {
  description = "The port on the container to associate with the load balancer."
}
variable "http_port" {
  description = "The HTTP port."
}
variable "ingress_cidr_blocks" {
  description = "List of Ingress CIDR blocks."
}

variable "log_retention" {
  description = "Days to retain logs in cloudwatch"
}

variable "region" {
  description = "Region of AWS resources"
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
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
}

variable "autoscaling_cooldown" {
  description = "Cooldown period before scaling rules apply."
}

variable "alarm_interval" {
  description = "Cloudwatch alarm interval"
}

variable "alarm_metric" {
  description = "Cloudwatch alarm metric"
}
variable "autoscaling_min_capacity" {
  description = "Minimum number of instances at all times."
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of instances scaled up auto scaling rules"
}

variable "scaling_adjustment_up" {
  description = "Number of instances the scaling rule increase."
}

variable "scaling_adjustment_down" {
  description = "Number of instances the scaling rule decrease."
}

variable "alarm_statistic" {
  description = "Cloudwatch alarm statistic"
}

variable "alarm_threshold_high" {
  description = "Cloudwatch alarm high threshold"
}

variable "alarm_threshold_low" {
  description = "Cloudwatch alarm low threshold"
}