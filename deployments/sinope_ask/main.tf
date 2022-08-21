terraform {
  cloud {
    organization = "elizabeth-dev"
    workspaces {
      name = "sinope-ask"
    }
  }

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.20.2"
    }
  }
}

variable "sinope_host" {
  type = string
}

provider "docker" {
  host     = var.sinope_host
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

/* Sinope Copper */

variable "sinope_mongodb_uri" {
  type = string
  sensitive = true
}

data "docker_registry_image" "sinope-copper" {
  name = "public.ecr.aws/s1m7q0k0/sinope-copper:latest"
}

resource "docker_image" "sinope-copper" {
  name          = data.docker_registry_image.sinope-copper.name
  pull_triggers = [data.docker_registry_image.sinope-copper.sha256_digest]
}

resource "docker_container" "sinope-copper" {
  name  = "sinope-copper"
  image = docker_image.sinope-copper.latest
  restart = "always"

  env = [
    "MONGODB_URI=${var.sinope_mongodb_uri}",
    "GOOGLE_APPLICATION_CREDENTIALS=/tmp/client_config.json",
    "GOOGLE_CLOUD_PROJECT=test-sinope"
  ]

  ports {
    internal = 8080
    external = 8080
  }

  ports {
    internal = 8081
    external = 8081
  }

  volumes {
    container_path = "/tmp/client_config.json"
    host_path = "/tmp"
  }
}

/* Sinope Ask */
/*
data "docker_registry_image" "sinope_ask" {
  name = "public.ecr.aws/s1m7q0k0/sinope_ask:latest"
}

resource "docker_image" "sinope_ask" {
  name          = data.docker_registry_image.sinope_ask.name
  pull_triggers = [data.docker_registry_image.sinope_ask.sha256_digest]
}

resource "docker_container" "sinope_ask" {
  name  = "sinope_ask"
  image = docker_image.sinope_ask.latest
  restart = "always"

  ports {
    internal = 3000
    external = 3000
  }
}
*/
/* Caddy LB */
/*
data "docker_registry_image" "sinope_lb" {
  name = "public.ecr.aws/s1m7q0k0/sinope_lb:latest"
}

resource "docker_image" "sinope_lb" {
  name          = data.docker_registry_image.sinope_lb.name
  pull_triggers = [data.docker_registry_image.sinope_lb.sha256_digest]
}

resource "docker_container" "sinope_lb" {
  name  = "sinope_lb"
  image = docker_image.sinope_lb.latest
  restart = "always"

  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 443
    external = 443
  }

  ports {
    internal = 443
    external = 443
    protocol = "udp"
  }
}*/
