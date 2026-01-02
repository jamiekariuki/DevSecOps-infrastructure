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


output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = module.db.db_instance_master_user_secret_arn
}