 //kms encryption for eks secrets in etcd
resource "aws_kms_key" "k8s_encryption" {
  description             = "KMS key for encrypting EKS secrets"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

//roles arn from identity center
locals {
  admin_role_arn = one(data.aws_iam_roles.admin_sso_role.arns)
  dev_role_arn   = one(data.aws_iam_roles.dev_sso_role.arns)
  qa_role_arn    = one(data.aws_iam_roles.qa_sso_role.arns)
}

//eks
module "eks" {
  depends_on = [ module.aws-iam-identity-center ]
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.33"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  encryption_config = {
    provider_key_arn = aws_kms_key.k8s_encryption.arn
    resources        = ["secrets"]
  }

  
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3a.xlarge", "t3.xlarge", "t3a.2xlarge"]

      capacity_type = "SPOT"

      min_size     = 1
      max_size     = 3
      desired_size = 1
    }
  }

  #acces entries
  access_entries = {
    # admin
    admin = {
      principal_arn = admin_role_arn
      kubernetes_groups = ["admin"]

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
    # qa
    qa = {
      principal_arn = qa_role_arn
      kubernetes_groups = ["qa"]

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
    # admin
    dev = {
      principal_arn = dev_role_arn
      kubernetes_groups = ["dev"]

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }

  tags = {
    Terraform   = "true"
  }
}


//helm resource for argocd  (installing argocd)
 resource "helm_release" "argocd" {
  depends_on = [ module.eks ]
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.1.4"
  namespace        = "argocd"
  create_namespace = true

    values = [
    yamlencode({
      server = {
        service = {
          type = "LoadBalancer"
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
          }
        }
      }
    })
  ]  
} 


