output "cluster_id" {
  description = "The ID of the EKS cluster."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "The security group ID of the EKS cluster."
  value       = module.eks.cluster_security_group_id
}

output "cluster_autoscaler_irsa_role" {
  description = "This defines the output details of the cluster_autoscaler"
  value = module.cluster_autoscaler_irsa_role
}

output "iam_role_arn" {
  description = "This defines the iam role arn"
  value = module.cluster_autoscaler_irsa_role.iam_role_arn
}

output "cluster_autoscaler_role_arn" {
  value = module.cluster_autoscaler_irsa_role
}

# output "cluster_autoscaler_irsa_role" {
#   value = module.cluster_autoscaler_irsa_role
# }

# output "iam_role_arn" {
#   value = module.cluster_autoscaler_irsa_role.iam_role_arn
# }