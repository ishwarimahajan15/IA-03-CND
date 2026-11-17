output "container_name" {
  description = "Name of the provisioned Docker container"
  value       = docker_container.app.name
}
output "application_url" {
  description = "Local URL for the deployed application"
  value       = "http://localhost:${var.host_port}"
}
output "health_check_url" {
  description = "Application health endpoint"
  value       = "http://localhost:${var.host_port}/health"
}
