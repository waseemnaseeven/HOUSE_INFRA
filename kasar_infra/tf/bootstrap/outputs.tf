output "state_bucket_name" {
  value       = aws_s3_bucket.tf_state.bucket
  description = "Nom du bucket S3 pour les states Terraform"
}

output "state_bucket_arn" {
  value       = aws_s3_bucket.tf_state.arn
  description = "ARN du bucket S3"
}

output "lock_table_name" {
  value       = aws_dynamodb_table.tf_lock.name
  description = "Nom de la table DDB pour le lock"
}
