# Find the existing Infomaniak network.
data "openstack_networking_network_v2" "ext_net" {
  name = var.network_name
}

# Select the most recent Debian 10 Buster image available in the project.
data "openstack_images_image_v2" "debian10" {
  name_regex  = var.image_name_regex
  most_recent = true
}

# Security group for this VM.
#
# Infomaniak blocks incoming traffic by default, so SSH and HTTP are
# explicitly allowed here.
resource "openstack_networking_secgroup_v2" "instance" {
  name        = var.security_group_name
  description = "Security group for ${var.instance_name}: SSH from ${var.ssh_source_cidr}, HTTP from Internet"
}

# SSH: only the specified public IP.
resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.ssh_source_cidr
  security_group_id = openstack_networking_secgroup_v2.instance.id
}

# HTTP: Internet-wide access.
resource "openstack_networking_secgroup_rule_v2" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.instance.id
}

resource "openstack_compute_instance_v2" "debian10" {
  name            = var.instance_name
  image_id        = data.openstack_images_image_v2.debian10.id
  flavor_name     = var.flavor_name
  key_pair        = var.keypair_name
  security_groups = [openstack_networking_secgroup_v2.instance.name]

  network {
    uuid        = data.openstack_networking_network_v2.ext_net.id
    fixed_ip_v4 = var.fixed_ip
  }
}
