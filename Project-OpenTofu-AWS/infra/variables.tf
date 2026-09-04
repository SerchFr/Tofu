variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-3" # Paris
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "My-AWS-VM"
}

variable "ami_id" {
  description = "ID de l'AMI à utiliser (remplace var.image_name). Ex : Ubuntu 22.04 sur eu-west-3 = ami-0c1d7c47fa5b19b30)"
  type        = string
  default = "ami-0e1c4170d9c01184b"
}

variable "instance_type" {
  description = "Type d'instance AWS (remplace var.flavor_name). Ex : t3.micro"
  type        = string
  default     = "t3.micro"
}

variable "keypair_name" {
  description = "Nom donné à la paire de clés AWS"
  type        = string
  default     = "Key-AWS.pem"
}

variable "ssh_public_key" {
  description = "Chemin vers votre clé publique SSH (identique à avant)"
  type        = string
}
