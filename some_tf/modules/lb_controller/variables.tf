variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "cluster_oidc_arn" {
  description = "ARN du provider OIDC du cluster"
  type        = string
}

variable "region" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
}
