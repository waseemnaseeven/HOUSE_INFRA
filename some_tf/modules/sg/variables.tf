variable "name" {
    description = "Name of the security group"
    type        = string
}

variable "description" {
    description = "Purpose of these security group"
    type        = string
    default     = ""
}

variable "vpc_id" {
    description = "VPC id"
    type        = string
}

variable "ingress_rules" {
    type = list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
        description = optional(string)
  }))
    default = []
}

variable "egress_rules" {
    type = list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
        description = optional(string)
  }))
    default = []
}

variable "tags" {
  description = "tags for sg"
  type        = map(string)
  default     = {}
}

