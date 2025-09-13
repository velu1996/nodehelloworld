variable "image_name" {
  description = "Docker image name"
  type        = string
  default = "raghdasallam99/hello-world-node:latest"
}

variable "container_name" {
  description = "Docker container name"
  type        = string
  default     = "nodejs-app"
}

variable "host_port" {
  description = "Port exposed on localhost"
  type        = number
  default     = 3000
}

variable "container_port" {
  description = "Port exposed in container"
  type        = number
  default     = 3000
}
