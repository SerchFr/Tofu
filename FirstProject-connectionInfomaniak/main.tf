terraform {
  required_version = ">= 1.6.0"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4"
    }
  }
  backend "s3" {
    bucket   = "my-first-container"
    key      = "My-First-S3/terraform.tfstate1" # Path and filename inside the bucket
    region   = "us-east-1"               # Infomaniak ignores this, but a value is required by the S3 plugin

    # Infomaniak S3 custom endpoints
    endpoint     = "https://s3.pub1.infomaniak.cloud"
    #sts_endpoint = "https://infomaniak.cloud"

    use_path_style = true
    # Required settings for non-AWS S3 providers
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    #use_path_style             = true # Forces path-style URLs (bucket.endpoint vs endpoint/bucket)
  }
}

provider "openstack" {
#  auth_url    = var.auth_url
#  region      = var.region
#  user_name   = var.username
#  tenant_name = var.project_id
#  password    = var.password
#  cloud       = "PCU-C3G3EWA"
  #cloud = "/media/sergio/01DB9177DBBFFDD0/Cloud_ex/Infomaniak/PCU-C3G3EWA-clouds.yaml"
  cloud = "PCP-C3G3EWA-dc3-a"
  #clouds_yaml_path = "/media/sergio/01DB9177DBBFFDD0/Cloud_ex/Infomaniak/PCU-C3G3EWA-clouds.yaml"  
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
