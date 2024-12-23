# PostgreSQL deployment
resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = var.namespace
    labels = {
      app = "postgres"
    }
  }

  spec {
    replicas = var.postgres_replica_count

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:13"

          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_DB"
            value = var.postgres_database
          }

          env {
            name  = "POSTGRES_USER"
            value = var.postgres_username
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_secret.metadata[0].name
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "postgres-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

# PostgreSQL Service
resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgres"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = 5432
    }
  }
}

# PostgreSQL PVC
resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name      = "postgres-pvc"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "${var.storage_size_in_gb}Gi"
      }
    }
    storage_class_name = var.storage_class
  }
}

# PostgreSQL Secret
resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = "postgres-secret"
    namespace = var.namespace
  }

  data = {
    password = var.postgres_password
  }
}