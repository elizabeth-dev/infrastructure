terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.20.2"
    }
  }
}

variable "host" {
  type = string
}

variable "host_privkey" {
  type = string
  sensitive = true
}

variable "mongodb_uri" {
  type = string
  sensitive = true
}

provider "docker" {
  host     = var.host
  key_material = var.host_privkey
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

/* Sinope Core */

data "docker_registry_image" "sinope_core" {
  name = "public.ecr.aws/s1m7q0k0/sinope_core:latest"
}

resource "docker_image" "sinope_core" {
  name          = data.docker_registry_image.sinope_core.name
  pull_triggers = [data.docker_registry_image.sinope_core.sha256_digest]
}

resource "docker_container" "sinope_core" {
  name  = "sinope_core"
  image = docker_image.sinope_core.latest
  restart = "always"

  env = ["MONGODB_URI=${var.mongodb_uri}"]

  ports {
    internal = 8080
    external = 8080
  }

  ports {
    internal = 8081
    external = 8081
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
