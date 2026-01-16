resource "aws_iam_policy" "aws_load_balancer_policy" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller with EKS Fargate"

  policy = file("aws-load-balancer-controller-policy.json")
}

resource "aws_iam_role" "alb_irsa_role" {
  name = "AmazonEKSLoadBalancerControllerRole"
  
   assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn # <-- your EKS OIDC provider
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            # This must match the namespace and service account you will create in Kubernetes
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "alb_irsa_policy_attach" {
  role = aws_iam_role.alb_irsa_role.name
  policy_arn = aws_iam_policy.aws_load_balancer_policy.arn
}

