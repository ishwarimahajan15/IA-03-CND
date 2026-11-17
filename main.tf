variable "image_name" {
  description = "Docker image name built by Jenkins"
  type        = string
  default     = "jenkins-terraform-demo"
}
variable "image_tag" {
  description = "Docker image tag built by Jenkins"
  type        = string
  default     = "ci"
}
variable "container_name" {
  description = "Name of the managed container"
  type        = string
  default     = "jenkins-terraform-demo"
}
variable "host_port" {
  description = "Host port exposed for the application"
  type        = number
  default     = 5001
}
resource "docker_image" "app" {
  name         = "${var.image_name}:${var.image_tag}"
  keep_locally = true
}
resource "docker_container" "app" {
  name  = var.container_name
  image = docker_image.app.image_id
  ports {
    internal = 5000
    external = var.host_port
    ip       = "0.0.0.0"
  }
  env     = ["APP_VERSION=1.0.0"]
  restart = "unless-stopped"
}
