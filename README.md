# eso-aws-secret-eks-terraform

## Overview
This project is designed to provision AWS infrastructure using Terraform, specifically focusing on setting up an Elastic Kubernetes Service (EKS) cluster with associated resources such as a Virtual Private Cloud (VPC), IAM Roles for Service Accounts (IRSA), and AWS Secrets Manager.

## Project Structure
The project is organized into the following main components:

- **main.tf**: The main entry point for the Terraform configuration, containing resource definitions.
- **providers.tf**: Specifies the required providers and their configurations.
- **backend.tf**: Configures the backend for storing the Terraform state.
- **variables.tf**: Defines input variables for parameterization.
- **outputs.tf**: Specifies output values returned after infrastructure creation.
- **terraform.tfvars**: Contains values for the input variables for easy customization.

### Modules
The project includes several modules to encapsulate specific functionalities:

- **vpc**: Contains resources for setting up the Virtual Private Cloud.
  - `main.tf`: Resource definitions for the VPC.
  - `variables.tf`: Input variables for the VPC module.
  - `outputs.tf`: Output values for the VPC module.

- **eks**: Contains resources for setting up the Elastic Kubernetes Service.
  - `main.tf`: Resource definitions for EKS.
  - `variables.tf`: Input variables for the EKS module.
  - `outputs.tf`: Output values for the EKS module.

- **irsa**: Contains resources for IAM Roles for Service Accounts.
  - `main.tf`: Resource definitions for IRSA.
  - `variables.tf`: Input variables for the IRSA module.
  - `outputs.tf`: Output values for the IRSA module.

- **eso**: Contains resources related to AWS Secrets Manager and other configurations.
  - `main.tf`: Resource definitions for the ESO module.
  - `variables.tf`: Input variables for the ESO module.
  - `outputs.tf`: Output values for the ESO module.

### Bootstrap
- **bootstrap/s3_backend.tf**: Used to bootstrap the S3 bucket for storing the Terraform state.

## Setup Instructions
1. Clone the repository to your local machine.
2. Navigate to the project directory.
3. Update the `terraform.tfvars` file with your specific configuration values.
4. Initialize the Terraform project by running:
   ```
   terraform init
   ```
5. Plan the infrastructure changes:
   ```
   terraform plan
   ```
6. Apply the changes to provision the infrastructure:
   ```
   terraform apply
   ```

## Usage Guidelines
- Ensure you have the necessary AWS credentials configured in your environment.
- Review the output values after applying the configuration for important information about the provisioned resources.
- Modify the input variables in `terraform.tfvars` as needed for different environments or configurations.

## License
This project is licensed under the MIT License.