# Ads automaticly all namespaces to the cluster that are saved in the YAML files.

resource "kubernetes_manifest" "namespace" {
  for_each = fileset("${path.module}/k8s/namespaces", "*.yaml")

  manifest = yamldecode(
    file("${path.module}/k8s/Namespaces/${each.value}")
  )
}

resource "kubernetes_manifest" "services" {
  for_each = fileset("${path.module}/k8s/services", "*.yaml")

  manifest = yamldecode(
    file("${path.module}/k8s/services/${each.value}")
  )

  depends_on = [ kubernetes_manifest.namespace ]
}

resource "kubernetes_manifest" "ingress" {
  for_each = fileset("${path.module}/k8s/ingress", "*.yaml")

  manifest = yamldecode(
    file("${path.module}/k8s/ingress/${each.value}")
  )

  depends_on = [ kubernetes_manifest.services ]
}


resource "kubernetes_manifest" "deployments" {
  for_each = fileset("${path.module}/k8s/deployments", "*.yaml")

  manifest = yamldecode(
    file("${path.module}/k8s/deployments/${each.value}")
  )

  depends_on = [ kubernetes_manifest.services ]

}





