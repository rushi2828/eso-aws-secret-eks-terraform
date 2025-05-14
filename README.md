## 📦 External Secrets Operator with AWS Secrets Manager via IRSA on Amazon EKS

### 📖 Project Overview

This project demonstrates how to securely integrate AWS Secrets Manager with a Kubernetes cluster running on Amazon EKS using the External Secrets Operator (ESO) and IAM Roles for Service Accounts (IRSA). It provides a complete infrastructure-as-code implementation using Terraform and Helm, following AWS and Kubernetes best practices.
By using IRSA, the project ensures secure, short-lived credential access to AWS Secrets Manager, avoiding the need to store AWS credentials in Kubernetes Secrets

---

### 🎯 Features

✅ Deploys a production-grade Amazon EKS cluster with OIDC provider enabled.

✅ Creates an IAM role with appropriate Secrets Manager permissions.

✅ Configures IRSA to bind the IAM role to the ESO service account.

✅ Provisions External Secrets Operator using Helm.

✅ Creates a test secret in AWS Secrets Manager.

✅ Syncs secret values to Kubernetes Secrets using ESO.

✅ Includes a test pod to validate secret injection.

---

### 🧰 Stack

| Component                     | Description                                      |
| ----------------------------- | ------------------------------------------------ |
| **Terraform**                 | Manages EKS, IAM, IRSA, and AWS infrastructure   |
| **Helm**                      | Installs External Secrets Operator into EKS      |
| **AWS Secrets Manager**       | Stores and manages sensitive data securely       |
| **External Secrets Operator** | Syncs secrets from external providers            |
| **EKS (IRSA enabled)**        | Provides IAM role assumption via service account |
---

### 🗂️ Project Structure
```
eso-aws-secret-eks-terraform/
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│   └── eks-irsa.tf
├── manifests/
│   ├── secret-store.yaml
│   ├── external-secret.yaml
├── aws/
│   └── create-secret.sh
├── README.md
```
---
### STEP 1: Deploy EKS + IRSA with Terraform
`terraform/main.tf`
```
provider "aws" {
  region = var.aws_region
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  subnet_ids      = var.subnet_ids
  vpc_id          = var.vpc_id

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }

  manage_aws_auth = true
}
```
`terraform/eks-irsa.tf`
```
data "aws_iam_policy_document" "external_secrets_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider_url}:sub"
      values   = ["system:serviceaccount:external-secrets:external-secrets"]
    }
  }
}

resource "aws_iam_role" "external_secrets_irsa" {
  name               = "ExternalSecretsIRSA"
  assume_role_policy = data.aws_iam_policy_document.external_secrets_assume_role.json
}

resource "aws_iam_role_policy_attachment" "attach_secretsmanager_policy" {
  role       = aws_iam_role.external_secrets_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
```

`terraform/variables.tf`
```
variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "external-secrets-demo"
}

variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
```
---
### 📦 STEP 2: Create AWS Secret
`aws/create-secret.sh`
```
#!/bin/bash
aws secretsmanager create-secret \
  --name demo/external-secret \
  --secret-string '{"username":"devops-user","password":"SuperSecret"}' \
  --region us-east-1
```
---
### 🧱 STEP 3: Deploy External Secrets Operator
```
helm repo add external-secrets https://charts.external-secrets.io
helm repo update

helm upgrade --install external-secrets external-secrets/external-secrets \
  --namespace external-secrets \
  --create-namespace \
  --set serviceAccount.name=external-secrets \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=<REPLACE_WITH_IRSA_ROLE_ARN>
```
---
### 📄 STEP 4: Create SecretStore
`manifests/01-secret-store.yaml`
```
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: aws-secrets-manager
spec:
  provider:
    aws:
      service: SecretsManager
      region: us-east-1
      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets
            namespace: external-secrets
```
---
### 🔑 STEP 5: Create ExternalSecret
`manifests/02-external-secret.yaml`
```
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: demo-secret
  namespace: external-secrets
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: ClusterSecretStore
  target:
    name: synced-secret
    creationPolicy: Owner
  data:
    - secretKey: username
      remoteRef:
        key: demo/external-secret
        property: username
    - secretKey: password
      remoteRef:
        key: demo/external-secret
        property: password
```
---
### ✅ STEP 6: Verify  with  Kubernates commands
```
kubectl get secrets synced-secret -n external-secrets -o yaml
kubectl describe externalsecret demo-secret -n external-secrets
```
---
