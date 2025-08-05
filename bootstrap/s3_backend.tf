resource "aws_s3_bucket" "terraform_state" {
  bucket        = "eso-aws-secret-eks-tfstate-prd"
  force_destroy = true
  tags          = { Name = "Terraform State Bucket" }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "eso-aws-secret-eks-tfstate-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}