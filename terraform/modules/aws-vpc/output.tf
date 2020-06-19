output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${aws_vpc.default.id}"
}

output "public_subnets_ids" {
  description = "List with the Public Subnets IDs"
  value       = "${aws_subnet.default.*.id}"
}