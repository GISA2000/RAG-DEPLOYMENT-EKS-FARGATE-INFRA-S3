output "cluster_name" {
  value = aws_eks_cluster.rag_eks_cluster.name
}

output "endpoint" {
  value = aws_eks_cluster.rag_eks_cluster.endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.rag_eks_cluster.certificate_authority[0].data
}

output "alb_irsa_role" {
  description = "IAM role ARN for AWS Load Balancer Controller (IRSA)"
  value = aws_iam_role.alb_irsa_role.arn
}