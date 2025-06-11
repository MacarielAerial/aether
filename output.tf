output "instance_ip" {
  description = "IP address of the deployed Linode instance"
  value       = module.linode_config.instance_ip
}

output "public_ip" {
  description = "The public IPv4 address of the Linode"
  value       = module.linode_config.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh root@${module.linode_config.instance_ip}"
}
