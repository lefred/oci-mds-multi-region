output "mds_instance_ip_source" {
  value = module.mds-instance.private_ip
}

output "mds_instance_ip_replica" {
  value = module.mds-instance_replica.private_ip
}

output "shell_ip_source" {
  value = module.mysql-shell-source.public_ip
}

output "shell_ip_replica" {
  value = module.mysql-shell-replica.public_ip
}

output "ssh_private_key" {
  value = local.private_key_to_show
  sensitive = true
}

