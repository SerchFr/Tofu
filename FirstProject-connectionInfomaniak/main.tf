terraform {
  required_version = ">= 1.6.0"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4"
    }
  }
  backend "s3" {
    bucket   = var.bucket_name
    key      = var.bucket_repertory # Path and filename inside the bucket
    region   = var.region

    # Infomaniak S3 custom endpoints
    endpoint     = var.endpoint

    use_path_style = true
    # Required settings for non-AWS S3 providers
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    #use_path_style             = true # Forces path-style URLs (bucket.endpoint vs endpoint/bucket)
  }
}

provider "openstack" {
#  cloud = "PCP-C3G3EWA-dc3-a"
  cloud = var.project_id 
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
  #security_groups = [openstack_networking_secgroup_v2.my_security_group.name]
  security_groups = ["default"]

  network {
    name = var.network_name
  }
}
