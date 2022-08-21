terraform {
  cloud {
    organization = "elizabeth-dev"
    workspaces {
      name = "instances"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.27.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.2.0"
    }
  }
}
