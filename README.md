# eso-aws-secret-eks-terraform

## Overview

This project automates the creation of a secure, production-ready AWS Elastic Kubernetes Service (EKS) cluster, with full Amazon VPC networking and seamless secret management using the External Secrets Operator (ESO) and AWS Secrets Manager. All resource provisioning and cluster add-ons are managed via [Terraform](https://www.terraform.io/), following best practices for security, modularity, and scalability.

## How it Works:

- **Amazon EKS** creates a Kubernetes cluster in the cloud so you can run your applications securely and reliably.
- **Amazon VPC** provides private and public networks for your workloads—think of it as the "home" for your cluster.
- **AWS Secrets Manager** stores your passwords, API keys, and credentials **securely** in the cloud.
- **External Secrets Operator (ESO)** is an app running inside your cluster that automatically takes secrets from AWS Secrets Manager and puts them safely into your Kubernetes applications, so you never have to copy them by hand.
- **Terraform** is like an automated architect—it builds, changes, and tears down all these resources with simple, repeatable commands and code.


## Architecture:

```
AWS Cloud
┌────────────┐         ┌─────────────┐
│  AWS VPC   │───┬────▶│  EKS       │
└────────────┘   │     │  Cluster   │
                 └──┐  └─────────────┘
                    │          ▲
            [🕸 NAT/IGW]       │
                    ▼          │
         ┌───────────────────┐ │
         │ External Secrets  │─┘
         │ Operator (ESO)    │
         └───────────────────┘      ┌────────────────────┐
                    ▲               │ AWS Secrets Manager│
                    └───────────────┴────────────────────┘
```


## Features

- **Modular:** Dedicated modules for VPC, EKS, IRSA (IAM Role for Service Account), and ESO.
- **Best Practices:** Encrypted, versioned Terraform state on S3 with locking via DynamoDB.
- **Automated Networking:** Public/private subnets, NAT, and IGW for secure traffic flow.
- **Zero Secret Leaks:** Never copy-paste secrets—ESO keeps them safe and up-to-date.


## Prerequisites

- AWS account with administrative rights.
- [Terraform](https://www.terraform.io/downloads.html) v1.3+.
- [kubectl](https://kubernetes.io/docs/tasks/tools/) and [AWS CLI](https://docs.aws.amazon.com/cli/) configured (run `aws configure`, use a user with EKS/IAM/VPC permissions).


## Project Structure

```
eso-aws-secret-eks-terraform/
│
├── main.tf                # Root orchestrator
├── providers.tf           # Provider configs
├── backend.tf             # S3/DynamoDB remote state
├── variables.tf           # Input variables
├── terraform.tfvars       # Actual values for your deployment
├── outputs.tf             # Exported outputs
├── modules/
│   ├── vpc/               # VPC, subnets, IGW, NAT
│   ├── eks/               # EKS managed by official TF module
│   ├── irsa/              # IRSA + IAM for ESO
│   └── eso/               # ESO Helm chart and ServiceAccount
└── bootstrap/
    └── s3_backend.tf      # Bootstrap S3+DynamoDB for remote state
└── k8s-resources/
    └── secret-store.yaml      # Defines a ClusterSecretStore resource
    └── external-secret.yaml   # Defines an ExternalSecret resource for ESO.
```


## Step-by-Step Guide

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/eso-aws-secret-eks-terraform.git
cd eso-aws-secret-eks-terraform
```


### 2. Bootstrap Terraform Remote State

```bash
cd bootstrap
terraform init
terraform apply  # Approve when prompted
cd ..
```

*Creates the S3 bucket \& DynamoDB table used by Terraform for state and locking.*

### 3. Initialize the Main Project

```bash
terraform init
```


### 4. Apply Terraform—Launch the Stack!

```bash
terraform plan      # Review what will be created (optional but recommended)
terraform apply     # Provision all AWS resources (approve when asked)
```

This may take 10–15 minutes as EKS and node groups become ready.

### 5. Configure `kubectl` For New EKS Cluster

```bash
aws eks --region ap-south-1 update-kubeconfig --name prod-eks-cluster
```


### 6. Check Cluster \& Pods

```bash
kubectl get nodes
kubectl get pods -A
```

You should see your EKS worker nodes and the ESO pods running in the `external-secrets` namespace.

### 7. Apply Custom Resource Manifests

> These files (`secret-store.yaml`, `external-secret.yaml`) connect ESO to AWS Secrets Manager and sync your first secrets!

```bash
kubectl apply -f k8s-resources/secret-store.yaml
kubectl apply -f k8s-resources/external-secret.yaml
```


### 8. Verify Everything on AWS Console

- **EKS Console:** Should show an active cluster with worker nodes.
- **VPC Console:** VPC, subnets, NAT, and IGW created.
- **IAM Console:** IRSA Role (`prod-eks-cluster-eso-irsa`) exists, trust policy includes your OIDC provider.
- **Secrets Manager:** Your sample secret exists and is synced by ESO.
- **S3 \& DynamoDB:** Terraform state and lock visible in ap-south-1.


### 9. Validate Secret Sync in Kubernetes

```bash
kubectl get secrets -n external-secrets
kubectl describe secret <the-synced-secret-name> -n external-secrets
```


## Cleaning Up

To remove all resources (WARNING: this destroys your EKS cluster and related AWS resources):

```bash
terraform destroy
```


## Troubleshooting \& Notes

- If you see "resource or output not found" errors, double-check your Terraform module output names!
- For module or provider updates, check the documentation and update version constraints accordingly.
- For info on how ESO syncs secrets, see [External Secrets Operator docs](https://external-secrets.io/).


## Credits

- Based on [terraform-aws-modules/eks](https://github.com/terraform-aws-modules/terraform-aws-eks), [External Secrets Operator](https://external-secrets.io/), best practices from AWS.

**Now you can safely and securely run secret-dependent apps on EKS with zero manual credential management, using only easy-to-reuse Terraform code!**

