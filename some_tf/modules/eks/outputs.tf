output "cluster_id" {
  description = "ID du cluster EKS"
  value       = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  description = "Endpoint API du cluster"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority" {
  description = "Données CA pour kubectl"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_oidc_issuer" {
  description = "URL du provider OIDC du cluster"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "node_group_name" {
  description = "Nom du node group"
  value       = aws_eks_node_group.workers.node_group_name
}