
data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.rag_eks_cluster.identity[0].oidc[0].issuer

depends_on = [ aws_eks_fargate_profile.default_namespace ]
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.rag_eks_cluster.identity[0].oidc[0].issuer

  client_id_list = [ "sts.amazonaws.com" ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
 ]

 depends_on = [ data.tls_certificate.eks_oidc ]
}

