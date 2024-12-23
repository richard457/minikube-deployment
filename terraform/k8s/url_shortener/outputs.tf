output "service_name" {
  value       = kubernetes_service.url_shortener.metadata[0].name
  description = "The name of the URL shortener service"
}

output "service_port" {
  value       = kubernetes_service.url_shortener.spec[0].port[0].node_port
  description = "The NodePort of the URL shortener service"
}