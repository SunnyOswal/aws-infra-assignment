output "load_balancer_https_listener" {
  description = "Listener of load balancer"
  value       = "${aws_lb_listener.http.id}"
}
output "load_balancer_security_group_id" {
  description = "The ID of the load balancer"
  value       = "${aws_security_group.lb-http-ingress-egress.id}"
}

output "load_balancer_target_group_arn" {
  description = "The ARN of load balancer's target group"
  value       = "${aws_lb_target_group.default.arn}"
}