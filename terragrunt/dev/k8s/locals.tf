locals {
  stage                      = "dev"
  nginx_service_port         = 80
  url_shortener_service_port = 8080
  postgres_replica_count     = 3
}
