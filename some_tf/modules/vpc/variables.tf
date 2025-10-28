variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_count" {
  description = "How many public subnets (spread across AZs)"
  type        = number
  default     = 3
}

variable "private_subnet_count" {
  description = "How many private subnets (spread across AZs)"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags to apply to all VPC resources"
  type        = map(string)
  default     = {}
}

