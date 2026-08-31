variable "auth_url" {
  description = "Infomaniak OpenStack Identity endpoint."
  type        = string
  default     = "https://api.pub1.infomaniak.cloud/identity"
}

variable "region" {
  description = "Infomaniak OpenStack region."
  type        = string
  default     = "dc3-a"
}

variable "instance_name" {
  description = "Name of the Debian VM."
  type        = string
  default     = "instance-1"
}

variable "network_name" {
  description = "Infomaniak network where the VM is attached."
  type        = string
  default     = "ext-net1"
}

variable "fixed_ip" {
  description = "Fixed/public IPv4 address assigned to the VM."
  type        = string
  default     = "195.15.202.18"
}

variable "flavor_name" {
  description = "Infomaniak flavor."
  type        = string
  default     = "a1-ram2-disk50-perf1"
}

variable "image_name_regex" {
  description = "Regex used to select the Debian 10 Buster image."
  type        = string
  default     = "^Debian 10.*buster.*"
}

variable "keypair_name" {
  description = "Existing OpenStack key pair name to inject into the VM."
  type        = string
}

variable "ssh_source_cidr" {
  description = "Public source IP allowed to SSH to the VM."
  type        = string
  default     = "90.38.162.195/32"
}

variable "security_group_name" {
  description = "Security group managed by this OpenTofu configuration."
  type        = string
  default     = "instance-1-sg"
}
