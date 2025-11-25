locals {
  namespaces = [
    "monitoring",
    "dev",
    "stage",
    "prod"
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
variable "repo_url" {
  type    = string
  default = "https://github.com/your-org/my-gitops-repo.git"
}

variable "target_revision" {
  type    = string
  default = "main"
}

locals {
  argocd_manifests = fileset("${path.module}/apps", "*.yaml.tpl")
}

resource "kubernetes_manifest" "argocd_apps" {
  for_each = { for f in local.argocd_manifests : f => f }

  manifest = yamldecode(
    templatefile("${path.module}/apps/${each.value}", {
      repo_url        = var.repo_url
      target_revision = var.target_revision
    })
  )
}


