terraform {
  backend "s3" {
    bucket         = "stbucket2103"
    key            = "ECS/terraform.tfstate"
    region         = "eu-west-2"
  }
}
