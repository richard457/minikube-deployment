output "service_name" {
  value = kubernetes_service.postgres.metadata[0].name
}

output "secret_name" {
  value = kubernetes_secret.postgres_secret.metadata[0].name
}