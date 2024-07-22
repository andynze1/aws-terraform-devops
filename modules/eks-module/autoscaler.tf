# Create IAM Role for Cluster Autoscaler
resource "aws_iam_role" "cluster_autoscaler_role" {
  name = "cluster-autoscaler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = module.eks.oidc_provider_arn
        },
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider_arn}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
          }
        }
      }
    ]
  })

  tags = {
    Name = "cluster-autoscaler"
  }
}

# Attach IAM Policy to the Role
resource "aws_iam_policy_attachment" "cluster_autoscaler_policy_attachment" {
  name       = "cluster-autoscaler-policy-attachment"
  roles      = [aws_iam_role.cluster_autoscaler_role.name]
  policy_arn  = "arn:aws:iam::aws:policy/AutoScalingClusterAutoscalerPolicy"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

# data "aws_iam_policy_document" "cluster_autoscaler" {
#   statement {
#     actions = [
#       "autoscaling:DescribeAutoScalingGroups",
#       "autoscaling:DescribeAutoScalingInstances",
#       "autoscaling:DescribeLaunchConfigurations",
#       "autoscaling:DescribeTags",
#       "autoscaling:SetDesiredCapacity",
#       "autoscaling:TerminateInstanceInAutoScalingGroup",
#       "ec2:DescribeLaunchTemplateVersions"
#     ]

#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "cluster_autoscaler_policy" {
#   name   = "eks-cluster-autoscaler-policy-${random_string.suffix.result}"
#   policy = data.aws_iam_policy_document.cluster_autoscaler.json
# }

