terraform {
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
