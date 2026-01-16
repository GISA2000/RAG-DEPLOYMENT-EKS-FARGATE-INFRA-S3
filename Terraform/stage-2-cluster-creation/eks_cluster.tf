data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../stage-1-vpc-creation/terraform.tfstate"
  }
}

data "aws_iam_role" "eks_cluster_iam_role" {
  name = "AmazonEKSAutoClusterRole"

}

data "aws_iam_role" "eks_node_iam_role" {
  name = "AmazonEKSAutoNodeRole"
  
}

resource "aws_eks_cluster" "rag_eks_cluster" {
name=var.cluster_name
version = var.eks_cluster_version
role_arn = data.aws_iam_role.eks_cluster_iam_role.arn

vpc_config {
 subnet_ids = data.terraform_remote_state.vpc.outputs.private_app_subnets
}

access_config {
  authentication_mode = "API"
}

tags = {
  Application="rag"
  eks_type="Fargate"
  eks_mode="Auto"
}
}

resource "aws_eks_fargate_profile" "default_namespace" {
  cluster_name = aws_eks_cluster.rag_eks_cluster.name
  fargate_profile_name = "default"
  pod_execution_role_arn = data.aws_iam_role.eks_node_iam_role.arn
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_app_subnets

  selector {
    namespace = "kube-system"
  }

  selector {
    namespace = "default"
  }
}


resource "aws_eks_fargate_profile" "rag_namespaces" {
  cluster_name = aws_eks_cluster.rag_eks_cluster.name
  fargate_profile_name = "rag-namespaces"
  pod_execution_role_arn = data.aws_iam_role.eks_node_iam_role.arn
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_app_subnets

  selector {
    namespace = "rag-workers"
  }

  selector {
    namespace = "rag-frontend"
  }

  selector {
    namespace = "rag-api"
  }

  selector {
    namespace = "rag-monitoring"
  }
}



