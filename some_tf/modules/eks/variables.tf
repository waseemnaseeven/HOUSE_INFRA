variable "cluster_name" {
  description = "EKS cluster name for purpose"
  type        = string
}

variable "kubernetes_version" {
  description = "Version Kubernetes (ex: 1.27)"
  type        = string
  default     = "1.27"
}

variable "cluster_role_arn" {
  description = "ARN du rôle IAM pour le control plane EKS"
  type        = string
}

variable "node_group_role_arn" {
  description = "ARN du rôle IAM pour les worker nodes"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnets for EKS API server"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnets for worker nodes"
  type        = list(string)
}

variable "security_group_cp_ids" {
  description = "SG IDs pour le control plane (port 443)"
  type        = list(string)
}

variable "security_group_worker_ids" {
  description = "SG IDs pour les worker nodes"
  type        = list(string)
  default     = []
}

variable "node_group_instance_types" {
  description = "Node instance type"
  type        = list(string)
  default     = [ "t3.small" ]
}

variable "node_group_min_size" {
  description = "Minimum nb of worker nodes"
  type        = number
  default     = 1 
}

variable "node_group_max_size" {
  description = "Maximum size of worker nodes"
  type        = number
  default     = 3 
}

variable "node_group_desired_size" {
  description = "Desired size of worker nodes"
  type        = number
  default     = 1
}

variable "endpoint_public_access" {
  description = "Autorizing public access"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Autorizing private access à l'endpoint API"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Apply tags"
  type        = map(string)
  default     = {}
}