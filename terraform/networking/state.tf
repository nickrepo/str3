terraform {
  backend "s3" {
    bucket         = "stbucket2103"
    key            = "VPC/terraform.tfstate"
    region         = "eu-west-2"
  }
}
