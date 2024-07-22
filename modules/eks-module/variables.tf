variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}

variable "subnets" {
  description = "A list of subnets to place the EKS cluster in."
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed."
  type        = string
}

variable "role_name_prefix" {
  description = "Prefix for the IAM role name."
  type        = string
  default     = "eks-cluster-autoscaler"
}
