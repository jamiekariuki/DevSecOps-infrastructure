locals {
  namespaces = [
    "monitoring",
    "externalsecret"
  ]
}

#namespaces
resource "kubernetes_namespace" "namespaces" {
  for_each = toset(local.namespaces)

  metadata {
    name = each.key
  }
}

resource "kubernetes_namespace" "env" {
  metadata {
    name = var.ENV_PREFIX
  }
}
 
#app of apps
resource "helm_release" "app_of_apps" {
  depends_on = [ kubernetes_namespace.env, kubernetes_namespace.namespaces ]

  name       = "apps"
  chart      = "${path.module}/apps"
  namespace  = "argocd"

  values = [
    file("${path.module}/apps/values.yaml")
  ]
}



