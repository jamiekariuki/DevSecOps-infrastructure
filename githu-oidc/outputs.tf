output "github_oidc_role" {
  description = "CICD GitHub role."
  value       = module.github-oidc.oidc_role
}