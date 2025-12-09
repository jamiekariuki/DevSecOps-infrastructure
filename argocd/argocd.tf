locals {
  namespaces = [
    "dev",
    "stage",
    "prod",
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

 
#app of apps
resource "helm_release" "app_of_apps" {
  depends_on = [ kubernetes_namespace.namespaces ]

  name       = "apps"
  chart      = "${path.module}/apps"
  namespace  = "argocd"

  values = [
    file("${path.module}/apps/values.yaml")
  ]
}


#test


