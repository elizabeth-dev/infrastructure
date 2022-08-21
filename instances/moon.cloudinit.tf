data "cloudinit_config" "moon-1" {
  gzip = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      "package_update": true,
      "packages": [
        "docker",
      ],
      "ntp": {
        "enabled": true,
        "ntp_client": "chrony",
        "packages": ["chrony"]
      }
    })
  }
}
