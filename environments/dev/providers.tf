terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 6.0.0"
    }
  }

  backend "s3" {
  bucket         = "terraform-308281189096-us-east-1-an"
  key            = "terraform/project-01/terraform.tfstate"
  region         = "us-east-1"
  encrypt        = true
  use_lockfile  = true
}
}
provider "aws" {
  region = "us-east-1"
}