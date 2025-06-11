variable "linode_token" {
  description = "Linode API Token"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "region" {
  description = "Linode region"
  type        = string
  nullable    = false
}

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
  nullable    = false
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key file for instance access"
  type        = string
  sensitive   = true
  nullable    = false
}
