terraform {
  backend "s3" {
    bucket         = "secure-webapp-terraform-state"  # غيّر الاسم لو عايز
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
