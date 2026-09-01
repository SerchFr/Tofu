variable "auth_url" {
  description = "Infomaniak OpenStack authentication URL"
  type        = string
  default     = "https://api.pub1.infomaniak.cloud/identity"
}

variable "region" {
  description = "Infomaniak OpenStack region"
  type        = string
  default     = "dc3-a"
}

variable "username" {
  description = "Infomaniak OpenStack username (PCU-...)"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "Infomaniak Public Cloud project ID (PCP-...)"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Infomaniak OpenStack password"
  type        = string
  sensitive   = true
}

variable "vm_name" {
  type    = string
  default = "opentofu-vm"
}

variable "image_name" {
  description = "Image available in Infomaniak"
  type        = string
  default     = "Debian 10 buster"
}

variable "flavor_name" {
  description = "VM flavor"
  type        = string
  default     = "a1-ram2-disk20-perf1"
}

variable "network_name" {
  description = "OpenStack network"
  type        = string
  default     = "ext-net1"
}

variable "keypair_name" {
  type    = string
  default = "opentofu-key"
}

variable "ssh_public_key" {
  description = "Path to your SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
