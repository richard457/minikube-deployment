variable "replica_count" {
  type = number
  validation {
    condition     = var.replica_count % 1 == 0 && var.replica_count >= 1
    error_message = "Replica count is a whole number with minimum value of 1"
  }
}


variable "namespace" {
  type        = string
  description = "Namespace, in which the application is deployed"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "nginx"
}

variable "nginx_service_port" {
  description = "service port"
  type        = number
}
variable "nginx_service_target_port" {
  type = number
}
variable "nginx_service_node_port" {
  type = number
}