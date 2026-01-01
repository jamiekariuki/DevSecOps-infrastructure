
//s3 remote bucket bucket
module "github-oidc_s3" {
  source  = "terraform-module/github-oidc-provider/aws"
  version = "~> 1"

  create_oidc_provider = true
  create_oidc_role     = true

  repositories              = ["${var.repository}:ref:refs/heads/${var.branch}"]
  oidc_role_attach_policies = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}