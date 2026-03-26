variable "aws_region" {
  description   = "AWS region of IAM"
  type          = string
  default       = "eu-west-1" 
}

variable "environment" {
  description = "The environment for IAM"
  type        = string
  default     = "global"
}