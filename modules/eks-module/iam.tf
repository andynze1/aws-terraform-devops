# Create IAM Policy
resource "aws_iam_policy" "allow_eks_access" {
  name        = "allow-eks-access"
  description = "Policy to allow EKS access"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["eks:DescribeCluster"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Create IAM Role
resource "aws_iam_role" "eks_admin_role" {
  name               = "eks-admin-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${module.vpc.vpc_owner_id}:root"
        }
      }
    ]
  })
}

# Attach IAM Policy to the Role
resource "aws_iam_role_policy_attachment" "eks_admin_policy_attachment" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn  = aws_iam_policy.allow_eks_access.arn
}

# Create IAM User
resource "aws_iam_user" "user1" {
  name = "user1"
}

# Create IAM Group
resource "aws_iam_group" "eks_admin_group" {
  name = "eks-admin-group"
}

# Attach Policy to Group
resource "aws_iam_group_policy_attachment" "eks_admin_group_policy_attachment" {
  group      = aws_iam_group.eks_admin_group.name
  policy_arn  = aws_iam_policy.allow_eks_access.arn
}

# Add User to Group
resource "aws_iam_group_membership" "eks_admin_group_membership" {
  group = aws_iam_group.eks_admin_group.name
  users = [aws_iam_user.user1.name]
  name = aws_iam_role.eks_admin_role.name
}
