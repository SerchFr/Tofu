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
  
  # ext net1
  network {
    name = var.network_name
  }
  # Private net
  network {
     name = openstack_networking_network_v2.private_net.name
  }
  user_data = file("${path.module}/cloud-init-network-fix.yaml")
  
}

## ---------------------------------------------------------------
## Private network + subnet
## ---------------------------------------------------------------
resource "openstack_networking_network_v2" "private_net" {
  name           = "internal-net"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name       = "internal-subnet"
  network_id = openstack_networking_network_v2.private_net.id
  cidr       = "10.10.0.0/24"
  ip_version = 4
  # No external gateway needed — this is a purely internal L2 segment.
  # If you DO want outbound internet from this subnet (e.g. apt updates),
  # you'll need a router with an external gateway — see note below.
  enable_dhcp = true
  no_gateway  = true   # <-- prevents Neutron from auto-assigning 10.10.0.1 as gateway
  dns_nameservers = [] 
}

## ---------------------------------------------------------------
## Security group for internal traffic (LDAP + whatever mail needs)
## ---------------------------------------------------------------
#resource "openstack_networking_secgroup_v2" "internal_sg" {
#  name                 = "internal-sg"
#  description          = "Traffic between LDAP and mail VM"
#  delete_default_rules = true
#}

## Allow LDAP (389) and LDAPS (636) only from inside the private subnet
#resource "openstack_networking_secgroup_rule_v2" "allow_ldap" {
#  direction         = "ingress"
#  ethertype         = "IPv4"
#  protocol          = "tcp"
#  port_range_min    = 389
#  port_range_max    = 389
#  remote_ip_prefix  = openstack_networking_subnet_v2.private_subnet.cidr
#  security_group_id = openstack_networking_secgroup_v2.internal_sg.id
#}
#
#resource "openstack_networking_secgroup_rule_v2" "allow_ldaps" {
#  direction         = "ingress"
#  ethertype         = "IPv4"
#  protocol          = "tcp"
#  port_range_min    = 636
#  port_range_max    = 636
#  remote_ip_prefix  = openstack_networking_subnet_v2.private_subnet.cidr
#  security_group_id = openstack_networking_secgroup_v2.internal_sg.id
#}
#
## Allow SSH only from your admin IP (adjust as needed)
#resource "openstack_networking_secgroup_rule_v2" "allow_ssh" {
#  direction         = "ingress"
#  ethertype         = "IPv4"
#  protocol          = "tcp"
#  port_range_min    = 22
#  port_range_max    = 22
#  remote_ip_prefix  = "0.0.0.0/0" # TODO: restrict to your admin IP/CIDR
#  security_group_id = openstack_networking_secgroup_v2.internal_sg.id
#}
#
## ---------------------------------------------------------------
## New mail VM — attached to the private network only
## (no floating/public IP unless you need external mail delivery
##  directly from this VM — see note below)
## ---------------------------------------------------------------
#resource "openstack_compute_keypair_v2" "mail_keypair" {
#  name       = var.keypair_name
#  public_key = file(var.ssh_public_key)  # your public key
#}

resource "openstack_compute_instance_v2" "mail_vm" {
  name            = "mail-server"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.vm.name
  #security_groups = [openstack_networking_secgroup_v2.internal_sg.name]
  security_groups = ["default"]
  
  # ext net1
  network {
    name = var.network_name
  }
  
  network {
    name = openstack_networking_network_v2.private_net.name
  }
  
  user_data = file("${path.module}/cloud-init-network-fix.yaml")
  #depends_on = [openstack_networking_subnet_v2.private_subnet]
}



