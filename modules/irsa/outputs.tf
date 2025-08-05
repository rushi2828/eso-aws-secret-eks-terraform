output "service_account_name" {
  value = var.service_account_name
}

output "irsa_role_arn" {
  value = aws_iam_role.irsa.arn
}
