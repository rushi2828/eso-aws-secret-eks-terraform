resource "kubernetes_namespace" "eso" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "eso" {
  metadata {
    name      = var.service_account
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = var.irsa_role_arn
    }
  }
}

resource "helm_release" "eso" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = var.namespace
  create_namespace = false
  values = [<<EOF
serviceAccount:
  create: false
  name: ${var.service_account}
EOF
  ]
}
