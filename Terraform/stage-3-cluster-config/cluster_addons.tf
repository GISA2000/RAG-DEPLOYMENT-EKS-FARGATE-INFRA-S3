#Adds the CoreDNS pods to the cluster so pods can talk to services trough DNS
resource "aws_eks_addon" "coredns" {
  cluster_name = var.cluster_name
  addon_name = "coredns"
  resolve_conflicts_on_create = "OVERWRITE"
  addon_version = var.coredns_version
 
}

