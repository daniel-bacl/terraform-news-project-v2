output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_exec_role.arn
}

output "bastion_ssm_profile_name" {
  value = aws_iam_instance_profile.bastion_ssm_profile.name
}
