module "aws-iam-identity-center" {
  source = "aws-ia/iam-identity-center/aws"

  // groups
  sso_groups = {
    Admin : {
      group_name        = "Admin"
      group_description = "Admin IAM Identity Center Group"
    },
    Dev : {
      group_name        = "Dev"
      group_description = "Dev IAM Identity Center Group"
    },
    QA : {
      group_name        = "QA"
      group_description = "QA IAM Identity Center Group"
    },
  }

  //users (should not be commited to git if you want to keep this private, use tfvars and apply it locally)
  sso_users = {
    jamesadmin : {
      group_membership = ["Admin"]
      user_name        = "jamesadmin"
      given_name       = "james"
      family_name      = "james kariuki"
      email            = "jamiekariuki18@gmail.com"
    },
    johnqa : {
      group_membership = ["QA"]
      user_name        = "johnqa"
      given_name       = "john"
      family_name      = "john doe"
      email            = "jamiekariuki18@gmail.com"
    },
    marydev : {
      group_membership = ["Dev"]
      user_name        = "marydev"
      given_name       = "mary"
      family_name      = "mary doe"
      email            = "jamiekariuki18@gmail.com"
    },
    peterdev : {
      group_membership = ["Dev"]
      user_name        = "peterdev"
      given_name       = "peter"
      family_name      = "peter doe"
      email            = "jamiekariuki18@gmail.com"
    },
  }

  // permissions sets 
  permission_sets = {
    AdministratorAccess = {
      description          = "Provides AWS full access permissions.",
      session_duration     = "PT12H", 
      aws_managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      tags                 = { ManagedBy = "Terraform" }
    },
    QaAccess = {
      description          = "Provides ec2 and s3 read access only permissions.",
      session_duration     = "PT12H", 
      aws_managed_policies = [
        "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
        "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
      ]
      tags                 = { ManagedBy = "Terraform" }
    },
    DevAccess = {
      description          = "Provides ec2, s3 (read) and rds access only permissions.",
      session_duration     = "PT12H", 
      aws_managed_policies = [
        "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
        "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
        "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
        #you can add more policies (managed by aws)
      ]
      tags                 = { ManagedBy = "Terraform" }
    },
    
  }

  // Assign users/groups access to accounts with the specified permissions
  account_assignments = {
    Admin : {
      principal_name  = "Admin"                                   
      principal_type  = "GROUP"                                  
      principal_idp   = "INTERNAL"                               
      permission_sets = ["AdministratorAccess"]  
      account_ids = [var.aws_account_id]
    },
    QA : {
      principal_name  = "QA"
      principal_type  = "GROUP"
      principal_idp   = "INTERNAL"
      permission_sets = ["QaAccess"]
      account_ids = [var.aws_account_id]
    },
    Dev : {
      principal_name  = "Dev"
      principal_type  = "GROUP"
      principal_idp   = "INTERNAL"
      permission_sets = ["DevAccess"]
      account_ids = [var.aws_account_id]
    },
  }
}

//discover the role arn 
data "aws_iam_roles" "admin_sso_role" {
  depends_on = [ module.aws-iam-identity-center ]
  name_regex  = "^AWSReservedSSO_AdministratorAccess_"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

data "aws_iam_roles" "dev_sso_role" {
  depends_on = [ module.aws-iam-identity-center ]
  name_regex  = "^AWSReservedSSO_DevAccess_"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

data "aws_iam_roles" "qa_sso_role" {
  depends_on = [ module.aws-iam-identity-center ]
  name_regex  = "^AWSReservedSSO_QaAccess_"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}
