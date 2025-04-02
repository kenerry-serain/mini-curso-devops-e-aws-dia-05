resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.eks_cluster.node_group_name
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = aws_subnet.private[*].id
  capacity_type   = var.eks_cluster.node_group_capacity_type
  instance_types  = var.eks_cluster.node_group_instance_types

  scaling_config {
    desired_size = var.eks_cluster.node_group_scaling_config_desired_size
    max_size     = var.eks_cluster.node_group_scaling_config_max_size
    min_size     = var.eks_cluster.node_group_scaling_config_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_group_AmazonEC2ContainerRegistryReadOnly,
  ]
}
