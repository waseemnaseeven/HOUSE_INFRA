locals {
  default_tags = {
    Terraform   = "true"
    Environment = var.environment
  }

  iam_groups = {
    admin = {
      users = ["wnaseeve", "antyro"]
      policies = {
        AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
      }
      tags = {
        Team = "ops"
      }
    }
    powerusers = {
      users = []
      policies = {
        PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess"
      }
      tags = {
        Team = "platform"
      }
    }
    developers = {
      users = []
      policies = {
        DeveloperReadOnly = "arn:aws:iam::aws:policy/ReadOnlyAccess"
        CloudWatchLogs    = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
      }
      tags = {
        Team = "dev"
      }
    }
    readonly = {
      users = ["audit"]
      policies = {
        ReadOnlyAccess = "arn:aws:iam::aws:policy/ReadOnlyAccess"
      }
      tags = {
        Team = "audit"
      }
    }
  }

  iam_users = {
    wnaseeve = {
      force_destroy           = true
      pgp_key                 = "keybase:wnaseeve"
      create_login_profile    = true
      password_reset_required = true
      create_access_key       = true
      tags = {
        Team = "ops"
      }
    }
    antyro = {
      force_destroy           = true
      create_login_profile    = true
      password_reset_required = true
      create_access_key       = true
      tags = {
        Team = "ops"
      }
    }
    newdev = {
      force_destroy           = true
      create_login_profile    = true
      password_reset_required = true
      create_access_key       = false
      tags = {
        Team = "dev"
      }
    }
  }
}

module "iam_groups" {
  for_each = local.iam_groups

  source  = "terraform-aws-modules/iam/aws//modules/iam-group"
  version = "6.2.2"

  name  = each.key
  users = each.value.users

  policies = lookup(each.value, "policies", {})

  tags = merge(local.default_tags, lookup(each.value, "tags", {}))
}

module "iam_users" {
  for_each = local.iam_users

  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "6.2.2"

  name                    = each.key
  force_destroy           = lookup(each.value, "force_destroy", false)
  pgp_key                 = lookup(each.value, "pgp_key", null)
  create_login_profile    = lookup(each.value, "create_login_profile", false)
  password_reset_required = lookup(each.value, "password_reset_required", false)
  create_access_key       = lookup(each.value, "create_access_key", false)

  tags = merge(local.default_tags, lookup(each.value, "tags", {}))
}
