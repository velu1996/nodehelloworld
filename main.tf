provider "docker" {}

resource "docker_image" "nodejs_app" {
  name = var.image_name
}

resource "docker_container" "nodejs_app" {
  name  = var.container_name
  image = docker_image.nodejs_app.name

  ports {
    internal = var.container_port
    external = var.host_port
  }
}
