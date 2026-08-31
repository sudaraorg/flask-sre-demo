resource "kubernetes_namespace" "flask_demo" {
  metadata {
    name = "flask-demo"
  }
}

resource "kubernetes_deployment" "flask_demo" {
  metadata {
    name      = "flask-demo"
    namespace = kubernetes_namespace.flask_demo.metadata[0].name
    labels = {
      app = "flask-demo"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "flask-demo"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask-demo"
        }
      }

      spec {
        container {
          name              = "flask-demo"
          image             = "sudaranz/flask-demo:latest"
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask_demo" {
  metadata {
    name      = "flask-demo"
    namespace = kubernetes_namespace.flask_demo.metadata[0].name
  }

  spec {
    selector = {
      app = "flask-demo"
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "ClusterIP"
  }
}
