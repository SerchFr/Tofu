terraform {
  required_version = ">= 1.6.0"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4"
    }
  }
}

provider "openstack" {
  auth_url    = var.auth_url
  region      = var.region
  user_name   = var.username
  tenant_name = var.project_id
  password    = var.password
}

resource "openstack_compute_keypair_v2" "vm" {
  name       = var.keypair_name
  public_key = file(var.ssh_public_key)
}

resource "openstack_compute_instance_v2" "vm" {
  name            = var.vm_name
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.vm.name
  security_groups = ["default"]

  network {
    name = var.network_name
  }
}
