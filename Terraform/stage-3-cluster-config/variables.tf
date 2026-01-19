variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "coredns_version" {
  type = string
}
variable "cluster_name" {}

variable "frontend_domain_name" {
  type = string
  default = "rag.local.nl"
}
