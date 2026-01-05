locals {
  admin_role_arn = one(data.aws_iam_roles.admin_sso_role.arns)
  dev_role_arn   = one(data.aws_iam_roles.dev_sso_role.arns)
  qa_role_arn    = one(data.aws_iam_roles.qa_sso_role.arns)
}

output "admin_role_arn" {
  value = local.admin_role_arn
}

output "dev_role_arn" {
  value = local.dev_role_arn
}

output "qa_role_arn" {
  value = local.qa_role_arn
}



