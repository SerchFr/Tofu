output "instance_id" {
  description = "OpenStack instance ID."
  value       = openstack_compute_instance_v2.debian10.id
}

output "instance_name" {
  description = "Instance name."
  value       = openstack_compute_instance_v2.debian10.name
}

output "ip_address" {
  description = "Fixed IPv4 address."
  value       = var.fixed_ip
}

output "ssh_command" {
  description = "SSH command template."
  value       = "ssh -i /path/to/your/private-key debian@${var.fixed_ip}"
}

output "security_group" {
  description = "Security group attached to the VM."
  value       = openstack_networking_secgroup_v2.instance.name
}
