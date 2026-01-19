resource "kubernetes_ingress_v1" "frontend" {
  metadata {
    name      = "rag-frontend-ingress"
    namespace = "rag-frontend"
    annotations = {
      "kubernetes.io/ingress.class"                  = "alb"
      "alb.ingress.kubernetes.io/scheme"            = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"       = "ip"
      "alb.ingress.kubernetes.io/healthcheck-path"  = "/"
      "alb.ingress.kubernetes.io/healthcheck-port"  = "8501"
      "alb.ingress.kubernetes.io/listen-ports"      = jsonencode([{"HTTPS":443}])
      "alb.ingress.kubernetes.io/certificate-arn"  = aws_acm_certificate.rag-frontend_cert.arn
    }
  }

  spec {
    rule {
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "rag-frontend-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service_account_v1.aws_lb_controller_service_account,
    aws_eks_addon.coredns,
    kubernetes_manifest.services,
    aws_acm_certificate.rag-frontend_cert
  ]
}
