output "repository_url" {
  description = "The URL of the repository."
  value       = "${aws_ecr_repository.default.repository_url}"
}