# Roles to create : role_name -> { assume_policy = json policy, policies = [managed_policy_arns] }
variable "roles" {
  description = "Map des IAM Roles à créer avec leurs policies"
  type = map(object({
    assume_policy = string
    policies      = list(string)
  }))
  default = {}
}

/**
    Map of IAM groups and users to manage: group_name -> { policies = [policy_arn,...], path?, tags? }
*/

variable "groups" {
  description = "Groups creations with policies"
  type = map(object({
    policies = list(string)
    path     = optional(string, "/")
    tags     = optional(map(string), {})
  }))
  default = {}
}

variable "users" {
  description = "Map of IAM users to manage, their policies, group memberships, and optional access key creation"
  type = map(object({
    policies           = optional(list(string), [])
    groups             = optional(list(string), [])
    create_access_key  = optional(bool, false)
  }))
  default = {}
}