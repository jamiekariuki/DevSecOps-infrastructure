 output "irsa_arn" {
  value = module.external_secrets_irsa.arn
}

output "SecretsManager_arn" {
  value = module.db.db_instance_master_user_secret_arn
} 

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db.db_instance_address
}

output "db_instance_name" {
  description = "The database name"
  value       = module.db.db_instance_name
  sensitive = true
}

output "db_instance_port" {
  description = "The database port"
  value       = module.db.db_instance_port
}

output "frontend_repository_url" {
  value = module.ecr-frontend.repository_url
}

output "backend_repository_url" {
  value = module.ecr-backend.repository_url
}




