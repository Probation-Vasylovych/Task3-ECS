provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.1"
    }
  }

  backend "s3" {
    bucket       = "llm-ecs"
    region       = "us-east-1"
    key          = "ecs/llm-ecs.tfstate"
    encrypt      = true
    use_lockfile = true
  }


}