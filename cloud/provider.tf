terraform {
  backend "s3" {
    bucket = "fukurou-environment"
    key    = "homelab/homelab.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "5.23.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = pathexpand("~${var.oracle_private_key_path}")
  fingerprint      = var.fingerprint
  region           = var.region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
