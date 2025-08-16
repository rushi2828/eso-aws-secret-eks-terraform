variable "cluster_name" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "namespace" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "secrets_manager_access" {
  type    = bool
  default = false
}

variable "oidc_provider_url" {
  type = string
}
