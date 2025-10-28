output "id" {
  description = "ID of sg"
  value       = aws_security_group.this.id
}

output "arn" {
  description = "ARN of sg"
  value       = aws_security_group.this.arn
}