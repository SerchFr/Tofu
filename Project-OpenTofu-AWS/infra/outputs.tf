output "vm_public_ip" {
  description = "IP publique de la VM - à utiliser dans l'inventaire Ansible"
  value       = aws_instance.vm.public_ip
}

output "vm_id" {
  value = aws_instance.vm.id
}
