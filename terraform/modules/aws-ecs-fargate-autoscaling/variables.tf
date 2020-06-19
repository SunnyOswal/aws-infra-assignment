variable "cooldown" {
  description = "Cooldown period before scaling rules apply."
}

variable "ecs_cluster_name" {
  description = "Ecs cluster name"
}

variable "ecs_service_name" {
  description = "Ecs service name"
}
variable "interval" {
  description = "Cloudwatch alarm interval"
}

variable "metric" {
  description = "Cloudwatch alarm metric"
}

variable "min_capacity" {
  description = "Minimum number of instances at all times."
}

variable "max_capacity" {
  description = "Maximum number of instances scaled up auto scaling rules"
}

variable "service_name" {
  description = "Service name . This will be used as prefix for all service components resources names."
}

variable "scaling_adjustment_up" {
  description = "Number of instances the scaling rule increase."
}

variable "scaling_adjustment_down" {
  description = "Number of instances the scaling rule decrease."
}

variable "statistic" {
  description = "Cloudwatch alarm statistic"
}

variable "threshold_high" {
  description = "Cloudwatch alarm high threshold"
}

variable "threshold_low" {
  description = "Cloudwatch alarm low threshold"
}