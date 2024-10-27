provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.73.0"
    }
  }
  backend "s3" {
    bucket = "rafaelsvieira-my-bucket"
    key    = "terraform/statefile/lambda-container-deploy"
    region = "us-east-1"
  }
}
