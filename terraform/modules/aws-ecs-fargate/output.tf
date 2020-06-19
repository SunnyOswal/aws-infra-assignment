output "ecs_cluster_name" {
  description = "Ecs cluster name"
  value       = "${aws_ecs_cluster.default.name}"
}

output "ecs_service_name" {
  description = "Ecs service name"
  value       = "${aws_ecs_service.default.name}"
}