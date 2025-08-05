output "eso_service_account" {
  value = kubernetes_service_account.eso.metadata[0].name
}

output "eso_namespace" {
  value = kubernetes_namespace.eso.metadata[0].name
}

output "eso_release_name" {
  value = helm_release.eso.name
}
