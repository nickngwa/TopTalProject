terraform {
  backend "s3" {
    bucket = "nngwa-node-terraform-state"
    encrypt = true
    region = "us-east-1"
    key = "terraform-code/terraform.tfstate"
  }
}
