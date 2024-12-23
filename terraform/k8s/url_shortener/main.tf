# Create kubernetes namespace
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "${var.stage}-url-shortner-namespace"
  }
}

# PostgreSQL Module
module "postgres" {
  source = "./postgres_db"

  namespace              = kubernetes_namespace.namespace.metadata[0].name
  postgres_database      = var.postgres_database
  postgres_username      = var.postgres_username
  postgres_password      = var.postgres_password
  storage_class          = var.storage_class
  storage_size_in_gb     = var.postgres_storage_size_in_gb
  postgres_replica_count = var.postgres_replica_count
}

# URL Shortener deployment
resource "kubernetes_deployment" "url_shortener" {
  depends_on = [module.postgres]

  metadata {
    name      = "url-shortener"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = {
      app = "url-shortener"
    }
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = "url-shortener"
      }
    }

    template {
      metadata {
        labels = {
          app = "url-shortener"
        }
      }

      spec {
        container {
          name  = "url-shortener"
          image = "aria3ppp/url-shortener"

          port {
            container_port = local.url_shortener_service_port
          }

          env {
            name  = "SERVER_PORT"
            value = "8080"
          }
          env {
            name  = "POSTGRES_USER"
            value = var.postgres_username
          }
          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = module.postgres.secret_name
                key  = "password"
              }
            }
          }
          env {
            name  = "POSTGRES_HOST"
            value = module.postgres.service_name
          }
          env {
            name  = "POSTGRES_PORT"
            value = "5432"
          }
          env {
            name  = "POSTGRES_DB"
            value = var.postgres_database
          }

          liveness_probe {
            http_get {
              path = "/test/redirection-destination"
              port = 8080
            }
            initial_delay_seconds = 20
            period_seconds        = 10
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 5
          }

          readiness_probe {
            http_get {
              path = "/test/redirection-destination"
              port = 8080
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 5
          }
        }
      }
    }
  }
}

# URL Shortener Service
resource "kubernetes_service" "url_shortener" {
  metadata {
    name      = "url-shortener"
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  spec {
    selector = {
      app = "url-shortener"
    }

    type = "NodePort"
    port {
      port        = var.url_shortener_service_port
      target_port = var.url_shortener_service_target_port
      node_port   = var.url_shortener_service_node_port
    }
  }
}