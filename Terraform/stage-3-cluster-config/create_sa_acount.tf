data "terraform_remote_state" "eks_iam" {
  backend = "local"

  config = {
    path = "../stage-2-cluster-creation/terraform.tfstate"
  }
}

resource "kubernetes_service_account_v1" "aws_lb_controller_service_account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = data.terraform_remote_state.eks_iam.outputs.alb_irsa_role
    }
  }

}
