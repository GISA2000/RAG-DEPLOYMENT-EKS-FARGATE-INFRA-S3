# Ads automaticly all namespaces to the cluster that are saved in the YAML files.
resource "time_sleep" "wait_for_alb_webhook" {
  create_duration = "300s"
  depends_on = [ helm_release.aws_load_balancer_controller ]
}

resource "kubernetes_manifest" "deployments" {
  for_each = fileset("${path.module}/k8s/deployments", "*.yaml")

  manifest = yamldecode(
    file("${path.module}/k8s/deployments/${each.value}")
  )

  depends_on = [ kubernetes_service_account_v1.aws_lb_controller_service_account,
                 time_sleep.wait_for_alb_webhook,
                 aws_eks_addon.coredns ]
}

resource "kubernetes_manifest" "services" {
  for_each = fileset("${path.module}/k8s/services", "*.yaml")

  manifest = yamldecode(
    file("${path.module}/k8s/services/${each.value}")
  )
  depends_on = [ kubernetes_service_account_v1.aws_lb_controller_service_account,
                 aws_eks_addon.coredns,
                 kubernetes_manifest.deployments ]
}










