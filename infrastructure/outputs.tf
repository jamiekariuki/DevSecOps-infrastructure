

//identity center role arn
output "admin_role_arn" {
  value = data.aws_iam_roles.admin_sso_role.arns[0]
}

output "dev_role_arn" {
  value = data.aws_iam_roles.dev_sso_role.arns[0]
}

output "qa_role_arn" {
  value = data.aws_iam_roles.qa_sso_role.arns[0]
}


