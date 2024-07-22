# Local Variables
locals {
  env = terraform.workspace
}

# Network Module
module "network" {
  source               = "./modules/network"
  aws_region           = var.aws_region
  vpc_id               = var.vpc_id
  my_ip_address        = var.my_ip_address
  aws_instance_id      = var.aws_instance_id
  public_subnet_id     = var.public_subnet_id
  network_interface_id = var.network_interface_id
}

# VM Module
module "vm" {
  source        = "./modules/vm"
  instance_type = "t2.large"
  ami_id_ubuntu = var.ami_id_ubuntu

  public_subnet_id  = module.network.public_subnet_ids[0]  # Use the first public subnet ID
  private_subnet_id = module.network.private_subnet_ids[0] # Use the first private subnet ID

  public_subnet_ids  = module.network.public_subnet_ids  # List of public subnet IDs
  private_subnet_ids = module.network.private_subnet_ids # List of private subnet IDs

  vpc_id               = module.network.vpc_id
  security_group_id    = module.network.security_group_id
  aws_instance_id      = var.aws_instance_id
  network_interface_id = module.network.public_network_interface_ids[0] # Use the first network interface ID
}

# EKS Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name    = "vtech-eks-cluster"
  cluster_version = "1.28"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  eks_managed_node_groups = {
    general = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "general"
      }

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }

    spot = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "spot"
      }

      taints = [{
        key    = "market"
        value  = "spot"
        effect = "NO_SCHEDULE"
      }]

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = "staging"
  }

  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = module.vm.eks_admins_iam_role_arn
      username = module.vm.eks_admins_iam_role_name
      groups   = ["system:masters"]
    },
  ]

  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
  }
}

# EKS Cluster Data Source
data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_id
}

# Kubernetes Provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
    command     = "aws"
  }
}
