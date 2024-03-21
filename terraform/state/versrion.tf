terraform {
  required_providers {
    aws = {
      version = "= 5.41.0"
      source  = "hashicorp/aws"
    }
  }
  required_version = ">= 1.5.7"
}
