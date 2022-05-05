terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12.1"
    }
  }

  cloud {
    organization = "social-site"

    workspaces {
      name = "social-site"
    }
  }
}

provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_ACCESS_KEY_SECRET
}
