variable "vpc_cidr" {
  type    = string
  default = "10.15.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.15.0.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.15.1.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-1a"]
}

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

variable "ssm_path_prefix" {
  description = "Préfixe des paramètres SSM (runtime)"
  type        = string
  default     = "/snak/prod"
}

variable "backup_bucket_name" {
  description = "Bucket S3 pour les pg_dump (optionnel)"
  type        = string
  default     = "snakagent-pg-dumps-prod"
}