module "instances" {
  source = "./instances"
}

variable "sinope_ask_server" {
  type = string
}

variable "sinope_ask_server_privkey" {
  type = string
  sensitive = true
}

variable "sinope_ask_mongodb_uri" {
  type = string
  sensitive = true
}

module "sinope_ask" {
  source = "./deployments/sinope_ask"

  host = var.sinope_ask_server
  host_privkey = var.sinope_ask_server_privkey
  mongodb_uri = var.sinope_ask_mongodb_uri
}
