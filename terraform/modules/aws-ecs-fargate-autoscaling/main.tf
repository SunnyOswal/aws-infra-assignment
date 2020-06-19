resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = "${var.min_capacity}"
  max_capacity       = "${var.max_capacity}"
}

resource "aws_appautoscaling_policy" "up" {
  name               = "${var.service_name}-scale-up"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.cooldown}"
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = "${var.scaling_adjustment_up}"
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

resource "aws_appautoscaling_policy" "down" {
  name               = "${var.service_name}-scale-down"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.cooldown}"
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = "${var.scaling_adjustment_down}"
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${var.service_name}-cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "${var.metric}"
  namespace           = "AWS/ECS"
  period              = "${var.interval}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold_high}"

  dimensions = {
    ClusterName = "${var.ecs_cluster_name}"
    ServiceName = "${var.ecs_service_name}"
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "${var.service_name}-cpu-utilization-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "${var.metric}"
  namespace           = "AWS/ECS"
  period              = "${var.interval}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold_low}"

  dimensions = {
    ClusterName = "${var.ecs_cluster_name}"
    ServiceName = "${var.ecs_service_name}"
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}