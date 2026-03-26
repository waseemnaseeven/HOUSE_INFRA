output "iam_groups_overview" {
  description = "Summary of IAM groups with assigned users and AWS managed policies."
  value = {
    for name, cfg in local.iam_groups :
    name => {
      users    = cfg.users
      policies = keys(lookup(cfg, "policies", {}))
    }
  }
}

output "iam_user_console_access" {
  description = "IAM users that have console login profiles managed by Terraform."
  value = [
    for name, cfg in local.iam_users : name
    if lookup(cfg, "create_login_profile", false)
  ]
}

output "iam_user_access_key_ids" {
  description = "Access key IDs for IAM users where keys are provisioned."
  value = {
    for name, user in module.iam_users :
    name => try(user.this_iam_access_key_id, null)
  }
}
