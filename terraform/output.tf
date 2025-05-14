output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS Kubernetes API"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "Kubernetes version used for the EKS cluster"
  value       = module.eks.cluster_version
}

output "oidc_provider_arn" {
  description = "The ARN of the IAM OIDC Provider for IRSA"
  value       = module.eks.oidc_provider_arn
}

output "irsa_role_name" {
  description = "The name of the IAM Role used by ESO via IRSA"
  value       = aws_iam_role.external_secrets_irsa.name
}

output "irsa_role_arn" {
  description = "The ARN of the IAM Role used by ESO via IRSA"
  value       = aws_iam_role.external_secrets_irsa.arn
}

output "region" {
  description = "AWS Region in which resources are deployed"
  value       = var.aws_region
}
