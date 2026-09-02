variable "auth_url" {
  description = "Infomaniak OpenStack authentication URL"
  type        = string
  default     = "https://api.pub1.infomaniak.cloud/identity"
}

variable "endpoint" {
  description = "Infomaniak OpenStack cutom endpoint"
  type        = string
  default     = "https://s3.pub1.infomaniak.cloud"
}

variable "region" {
  description = "Infomaniak OpenStack region"
  type        = string
  default     = "us-east-1"
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
  description = "Name of the VM that will be created"
  type    = string
  default = "opentofu-vm"
}

variable "bucket_name" {
  description = "Name of the bucket repository"
  type    = string
  default = "my-first-container"
}

variable "bucket_repertory" {
  description = "Path and filename inside the bucket"
  type    = string
  default = "My-First-S3/terraform.tfstate1"
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
  description = "Name of the key pair created in infomaniak"
  type    = string
  default = "opentofu-key"
}

variable "ssh_public_key" {
  description = "Path to your SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
