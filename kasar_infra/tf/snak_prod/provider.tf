terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.4"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}
