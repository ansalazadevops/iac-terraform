Fterraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
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
