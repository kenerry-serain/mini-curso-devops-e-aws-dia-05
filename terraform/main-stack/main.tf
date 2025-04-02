terraform {
  backend "s3" {
    bucket         = "devops-na-nuvem-remote-backend"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "devops-na-nuvem-remote-backend"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.93"
    }
  }
}

provider "aws" {
  region = var.assume_role.region

  assume_role {
    role_arn = var.assume_role.role_arn
  }

  default_tags {
    tags = var.tags
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.this.id]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.this.id]
      command     = "aws"
    }
  }
}
