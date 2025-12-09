 output "irsa_arn" {
  value = module.external_secrets_irsa.arn
}

output "SecretsManager_arn" {
  value = module.db.db_instance_master_user_secret_arn
} 

output "frontend_repository_url" {
  value = module.ecr-frontend.repository_url
}

output "backend_repository_url" {
  value = module.ecr-backend.repository_url
}