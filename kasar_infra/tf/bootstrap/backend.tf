terraform {
  backend "s3" {
    bucket         = var.state_bucket_name
    key            = "bootstrap/${var.environment}/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = var.lock_table_name
    encrypt        = true
  }
}

