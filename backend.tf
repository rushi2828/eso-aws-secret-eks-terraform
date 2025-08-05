terraform {
  backend "s3" {
    bucket         = "eso-aws-secret-eks-tfstate-prd"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "eso-aws-secret-eks-tfstate-locks"
    encrypt        = true
  }
}