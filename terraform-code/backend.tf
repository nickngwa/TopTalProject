resource "aws_s3_bucket" "terraform_state" {
  bucket = "nngwa-node-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

terraform {
  backend "s3" {
    bucket = "nngwa-node-terraform-state"
    encrypt = true
    region = "us-east-1"
    key = "terraform-code/terraform.tfstate"
  }
}