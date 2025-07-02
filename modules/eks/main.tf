# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  enabled_cluster_log_types = ["api", "authenticator", "controllerManager", "scheduler"]

  tags = {
    Name = var.cluster_name
  }
}

# Launch Template for NodeGroup
resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "eks-node-"
  instance_type = "t3.medium"

  key_name = "my-kp"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.security_group_ids
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-node"
    }
  }
}

# EKS Node Group using Launch Template
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  tags = {
    Name = "${var.cluster_name}-ng"
  }
}

# OIDC Provider for IAM Roles for Service Accounts
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0c0e66e9a"]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}