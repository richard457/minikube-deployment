
resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = var.namespace
  }
  spec {
    replicas = var.replica_count
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      port        = var.nginx_service_port
      target_port = var.nginx_service_target_port
      node_port   = var.nginx_service_node_port
    }
  }
}