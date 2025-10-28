locals {
  # Flatten role-policy attachments
  role_policy_attach = {
    for item in flatten([
      for r, cfg in var.roles : [
        for policy in cfg.policies : {
          key        = "${r}-${basename(policy)}"
          role       = r
          policy_arn = policy
        }
      ]
    ]) : item.key => { role = item.role, policy_arn = item.policy_arn }
  }
  # Flatten group-policy attachments
  group_policy_attach = {
    for item in flatten([
      for grp, cfg in var.groups : [
        for policy in cfg.policies : {
          key        = "${grp}-${basename(policy)}"
          group      = grp
          policy_arn = policy
        }
      ]
    ]) : item.key => {
      group      = item.group
      policy_arn = item.policy_arn
    }
  }
  # Flatten user-policy attachments
  user_policy_attach = {
    for item in flatten([
      for usr, cfg in var.users : [
        for policy in cfg.policies : {
          key        = "${usr}-${basename(policy)}"
          user       = usr
          policy_arn = policy
        }
      ]
    ]) : item.key => {
      user       = item.user
      policy_arn = item.policy_arn
    }
  }
}


resource "aws_iam_role" "this" {
  for_each = var.roles
  name     = each.key
  assume_role_policy = each.value.assume_policy

  lifecycle { prevent_destroy = true }
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  for_each   = local.role_policy_attach
  role       = aws_iam_role.this[each.value.role].name
  policy_arn = each.value.policy_arn
}


resource "aws_iam_group" "this" {
  for_each = var.groups
  name     = each.key
  path     = each.value.path

  lifecycle { prevent_destroy = true }

}

# Attach policies to groups
resource "aws_iam_group_policy_attachment" "group_attach" {
  for_each = local.group_policy_attach
  group    = aws_iam_group.this[each.value.group].name
  policy_arn = each.value.policy_arn
}

# IAM Users
resource "aws_iam_user" "this" {
  for_each = var.users
  name     = each.key
    
  lifecycle { prevent_destroy = true }

}

# Access key
resource "aws_iam_access_key" "this" {
  for_each = { for usr, cfg in var.users : usr => cfg if cfg.create_access_key }
  user     = aws_iam_user.this[each.key].name
}

# Attach policies to users
resource "aws_iam_user_policy_attachment" "user_attach" {
  for_each = local.user_policy_attach
  user       = aws_iam_user.this[each.value.user].name
  policy_arn = each.value.policy_arn
}

# Group memberships for users (inverted mapping group -> list of users)
locals {
  group_to_users = {
    for grp in keys(var.groups) : grp => [for usr, cfg in var.users : usr if contains(cfg.groups, grp)]
  }
}

resource "aws_iam_group_membership" "membership" {
  for_each = { for grp, users in local.group_to_users : grp => users if length(users) > 0 }
  name  = each.key
  group = each.key
  users = each.value
}
