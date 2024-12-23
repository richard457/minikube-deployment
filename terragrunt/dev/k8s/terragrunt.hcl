
terraform {
  source = "../../../terraform//k8s"
}

inputs = {
  stage = "dev"
  
  replica_count = 2

  nginx_service_port = 30201
  nginx_service_target_port = 80
  nginx_service_node_port = 30201
  

  postgres_replica_count = 3
  postgres_storage_size_in_gb = 0.5

  url_shortener_service_port = 30301
  url_shortener_service_node_port = 30301
  url_shortener_service_target_port = 8080

  postgres_database = "admin"
  postgres_password = "admin"

  postgres_username = "admin"
  postgres_user_password = "admin"

  postgres_repmgr_database = "admin"
  postgres_repmgr_username = "admin"
  postgres_repmgr_password = "admin"

  postgres_pgpool_admin_username = "admin"
  postgres_pgpool_admin_password = "admin"
  kubernetes_pgpool_secret_admin_password_key = "admin"
  kubernetes_postgres_secret_postgres_password_key = "admin"
  kubernetes_postgres_secret_repmgr_password_key = "admin"
}

