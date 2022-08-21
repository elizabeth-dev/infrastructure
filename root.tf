module "instances" {
  source = "./instances"
}

output "moon-1_ip_addr" {
  value = "moon-1: ${module.instances.moon-1_ip_addr}"
}

output "moon-1_ipv6_addr" {
  value = "moon-1: ${module.instances.moon-1_ipv6_addr}"
}
