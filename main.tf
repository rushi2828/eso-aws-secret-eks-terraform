module "vpc" {
  source       = "./modules/vpc"
  cluster_name = var.cluster_name
  aws_region   = var.aws_region
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  public_subnets  = module.vpc.public_subnet_ids
  eks_version     = var.eks_version
}

module "irsa" {
  source               = "./modules/irsa"
  cluster_name         = module.eks.cluster_name
  oidc_provider_arn    = module.eks.oidc_provider_arn
  namespace            = "external-secrets"
  service_account_name      = "external-secrets-sa"
  secrets_manager_access = true
}

module "eso" {
  source          = "./modules/eso"
  namespace       = "external-secrets"
  service_account = module.irsa.service_account_name
  irsa_role_arn   = module.irsa.irsa_role_arn

  depends_on = [
    module.eks
  ]
}
