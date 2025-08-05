output "irsa_role_arn" {
  value = module.irsa.irsa_role_arn
}

output "irsa_service_account_name" {
  value = module.irsa.service_account_name
}

output "eso_service_account" {
  value = module.eso.eso_service_account
}

output "eso_namespace" {
  value = module.eso.eso_namespace
}

output "eso_release_name" {
  value = module.eso.eso_release_name
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_ca_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "eks_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "eks_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
