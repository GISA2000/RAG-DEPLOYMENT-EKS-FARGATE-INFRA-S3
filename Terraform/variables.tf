variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "cluster_name" {
  type    = string
  default = "rag_eks_fargate_cluster"
}


variable "eks_cluster_version" {
  type = string
  default = "1.34"
}

variable "coredns_version" {
  type = string
}

