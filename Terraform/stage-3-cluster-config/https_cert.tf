resource "aws_acm_certificate" "rag-frontend_cert" {
  private_key = file("${path.module}/certificate/rag.local.nl.key")
  certificate_body = file("${path.module}/certificate/rag.local.nl.pem")

  tags = {
    Application="rag"
    Micoroservice="rag-frontend"
  }
  
}