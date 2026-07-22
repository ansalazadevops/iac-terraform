terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  default_tags {
      tags = {
          Environment = "${var.environment}"
          Owner       = "${var.owner}"
          Project     = "${var.project}"
      }
  }
}
