provider "kubernetes" {
  config_path = "~/.kube/config"
  version = "1.7"
}

resource "kubernetes_pod" "jenkins" {
  metadata {
    name = "jenkins"
    labels = {
      App = "jenkins"
    }
  }

  spec {
    container {
      //image = "jenkins/jenkins:lts"
      //image = "johnle99/jenkins7"
      image = "johnle99/auto_jenkins"
      name  = "jenkins"

      port {
        container_port = 8080
      }
    }
  }
}

resource "kubernetes_service" "jenkins" {
  metadata {
    name = "jenkins"
  }
  spec {
    selector = {
      App = "${kubernetes_pod.jenkins.metadata.0.labels.App}"
    }
    port {
      port = 8080
      target_port = 8080
      node_port = 32000
    }
    type = "NodePort"
  }
}
