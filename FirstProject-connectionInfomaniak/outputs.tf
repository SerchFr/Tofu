output "vm_id" {
  description = "OpenStack ID of the VM"
  value       = openstack_compute_instance_v2.vm.id
}

output "vm_name" {
  value = openstack_compute_instance_v2.vm.name
}

output "vm_addresses" {
  description = "Addresses assigned to the VM"
  value       = openstack_compute_instance_v2.vm.access_ip_v4
}
