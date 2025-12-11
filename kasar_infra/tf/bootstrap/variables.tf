variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
  default     = "prod"
}

variable "state_bucket_name" {
  type        = string
  description = "Name of the S3 bucket that stores Terraform state."
  default     = "kasar-state-eu"
}

variable "lock_table_name" {
  type        = string
  description = "Name of the DynamoDB table used for Terraform state locking."
  default     = "kasar-lock-eu"
}