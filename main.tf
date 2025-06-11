terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 2.41.0"
    }
  }
  backend "local" {}
}

module "linode_config" {
  source         = "./modules/linode_config"
  region         = var.region
  ssh_public_key = var.ssh_public_key
  ssh_private_key_path = var.ssh_private_key_path
  linode_token   = var.linode_token
}
