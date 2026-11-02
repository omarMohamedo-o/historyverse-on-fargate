terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # Production state backend: uncomment and configure S3 + DynamoDB locking
  # backend "s3" {
  #   bucket         = "historyverse-terraform-state"
  #   key            = "ecs-fargate/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "historyverse-terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
