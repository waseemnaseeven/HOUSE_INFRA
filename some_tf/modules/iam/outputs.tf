output "role_arns" {
  description = "Map des noms de roles vers leurs ARNs"
  value       = { for r, role in aws_iam_role.this : r => role.arn }
}

output "group_names" {
  description = "Groups names"
  value       = keys(aws_iam_group.this)
}

output "user_names" {
  description = "Users names"
  value       = keys(aws_iam_user.this)
}

output "access_key_ids" {
  description = "Map of IAM user to Access Key ID when created"
  value       = { for u, key in aws_iam_access_key.this : u => key.id }
}

output "secret_access_keys" {
  description = "Map of IAM user to Secret Access Key when created"
  value       = { for u, key in aws_iam_access_key.this : u => key.secret }
}

