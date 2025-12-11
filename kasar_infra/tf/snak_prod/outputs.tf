output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnets[0]
}

output "private_subnet_id" {
  value = module.vpc.private_subnets[0]
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "security_group_id" {
  description = "Security group ARN/ID pour l’instance EC2 prod"
  value       = module.sg_common.security_group_id
}

output "edge_public_ip" {
  value = module.ec2_edge.public_ip
}

output "edge_private_ip" {
  value = module.ec2_edge.private_ip
}

output "edge_instance_id" {
  value = module.ec2_edge.id
}

output "edge_iam_role" {
  value = module.ec2_edge.iam_role_name
}
