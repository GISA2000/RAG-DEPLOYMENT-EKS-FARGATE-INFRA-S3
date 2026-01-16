# The code below creates 2 IAM roles "AmazonEKSAutoClusterRole" and "AmazonEKSAutoNodeRole" for the EKS cluster so that it has permission to function properly.
resource "aws_iam_role" "amazon_eks_auto_cluster_role" {
  name = "AmazonEKSAutoClusterRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        "Action": [
            "sts:AssumeRole",
            "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "amazon_eks_auto_cluster_role_polies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  ])

  role = aws_iam_role.amazon_eks_auto_cluster_role.name
  policy_arn = each.value

}

resource "aws_iam_role" "amazon_eks_auto_node_role" {
  name = "AmazonEKSAutoNodeRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement= [{
        Effect = "Allow"
        Principal= {
            Service= [ "ec2.amazonaws.com",
            "eks-fargate-pods.amazonaws.com"
            ]
        }
        Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "amazon_eks_auto_node_role_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"

 ]) 

 role = aws_iam_role.amazon_eks_auto_node_role.name
 policy_arn = each.value
}
