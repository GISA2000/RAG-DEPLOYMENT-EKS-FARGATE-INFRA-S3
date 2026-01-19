terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.13"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.18"
  }
}
}

data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "../stage-2-cluster-creation/terraform.tfstate"
  }
}

provider "aws" {
  region  = var.region
  
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_ca)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      var.cluster_name,
     
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_ca)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        var.cluster_name
      ]
    }
  }
}



