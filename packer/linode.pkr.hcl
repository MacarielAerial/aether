packer {
  required_plugins {
    linode = {
      version = ">= 1.6.5"
      source  = "github.com/hashicorp/linode"
    }
    ansible = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "linode_token" {
  type    = string
  default = "${env("LINODE_TOKEN")}"
}

variable "github_username" {
  type    = string
  default = "${env("GITHUB_USERNAME")}"
}

variable "github_pat" {
  type    = string
  default = "${env("GITHUB_PAT")}"
}

variable "frontend_username" {
  type    = string
  default = "${env("CHAINLIT_USERNAME")}"
}

variable "frontend_password" {
  type    = string
  default = "${env("CHAINLIT_PASSWORD")}"
}

variable "domain" {
  type    = string
  default = "${env("DOMAIN")}"
}

variable "email" {
  type    = string
  default = "${env("EMAIL")}"
}

variable "staging" {
  type    = string
  default = "${env("STAGING")}"
}

source "linode" "debian" {
  image         = "linode/debian11"
  instance_type = "g6-nanode-1"
  region        = "gb-lon"
  ssh_username  = "root"
  linode_token  = var.linode_token
}

build {
  sources = ["source.linode.debian"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y python3"
    ]
  }

  provisioner "ansible" {
    playbook_file = "../ansible/playbook.yml"
    user          = "root"
    use_proxy     = false
    extra_arguments = [
      "-e", "github_username=${var.github_username}",
      "-e", "github_pat=${var.github_pat}",
      "-e", "frontend_username=${var.frontend_username}",
      "-e", "frontend_password=${var.frontend_password}",
      "-e", "domain=${var.domain}",
      "-e", "email=${var.email}",
      "-e", "staging=${var.staging}",
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
