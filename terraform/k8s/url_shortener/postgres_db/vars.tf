variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "postgres_database" {
  type        = string
  description = "PostgreSQL database name"
}

variable "postgres_username" {
  type        = string
  description = "PostgreSQL username"
}

variable "postgres_replica_count" {
  type        = number
  description = "A number of replica required"
}

variable "postgres_password" {
  type        = string
  description = "PostgreSQL password"
  sensitive   = true
}

variable "storage_class" {
  type        = string
  description = "Storage class name for PostgreSQL PVC"
}

variable "storage_size_in_gb" {
  type        = number
  description = "Storage size in GB for PostgreSQL PVC"
}