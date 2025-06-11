data "external" "packer_image" {
  program = ["${path.module}/../../scripts/get-image-id.sh", "${path.module}/../../packer/manifest.json"]
}

provider "linode" {
  token = var.linode_token
}

resource "linode_instance" "nanode" {
  label           = "property-letting-assistant-1"
  image           = data.external.packer_image.result.artifact_id
  region          = var.region
  type            = "g6-nanode-1"
  authorized_keys = [var.ssh_public_key]

  root_pass = random_password.root_pass.result
}

resource "random_password" "root_pass" {
  length  = 16
  special = true
}

output "instance_ip" {
  value = linode_instance.nanode.ip_address
}

output "public_ip" {
  value = linode_instance.nanode.ipv4
}
