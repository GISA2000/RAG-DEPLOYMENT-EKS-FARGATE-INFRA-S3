data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../stage-1-vpc-creation/terraform.tfstate"
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account_v1.aws_lb_controller_service_account.metadata[0].name
    
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name = "vpcId"
    value = data.terraform_remote_state.vpc.outputs.vpc_id
  }

  depends_on = [ kubernetes_service_account_v1.aws_lb_controller_service_account
  ]
}
