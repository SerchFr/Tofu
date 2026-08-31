# OpenTofu - Infomaniak Debian 10 Buster VM

This configuration describes:

- VM name: `instance-1`
- OS: Debian 10 Buster
- Fixed IPv4: `195.15.202.18`
- Network: `ext-net1`
- Flavor: `a1-ram2-disk50-perf1`
- SSH ingress: TCP/22 from `90.38.162.195/32`
- HTTP ingress: TCP/80 from `0.0.0.0/0`
- Existing OpenStack key pair: supplied through `keypair_name`

The configuration creates a dedicated security group instead of modifying Infomaniak's `default` security group.

## 1. Authentication

Use the OpenStack credentials supplied by Infomaniak. Prefer sourcing your Infomaniak `openrc.sh` rather than putting a password in Terraform/OpenTofu files.

Example:

```bash
source ./openrc.sh
```

If your `openrc.sh` uses a different filename/location, source that file instead.

Check the credentials with:

```bash
openstack token issue
```

if the OpenStack CLI is installed.

## 2. Configure the key pair

Create `terraform.tfvars` from the example:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then set:

```hcl
keypair_name = "YOUR_EXISTING_INFOMANIAK_KEYPAIR_NAME"
```

This is the OpenStack key-pair name, NOT the path to your `.pem` file.

Your private key stays on your computer and is not managed by OpenTofu.

## 3. Initialize

```bash
tofu init
```

## 4. Validate

```bash
tofu fmt
tofu validate
```

## 5. Review

```bash
tofu plan
```

## 6. Apply

```bash
tofu apply
```

Review the plan carefully before confirming.

## Important: existing VM

If `instance-1` / `195.15.202.18` already exists and you want OpenTofu to MANAGE that existing VM rather than create a second one, do not run `tofu apply` yet.

First import the existing resources. The exact import IDs depend on the current OpenStack resource IDs. You can obtain them with:

```bash
openstack server list
openstack network list
openstack security group list
openstack image list --name "Debian"
openstack flavor list
```

The configuration deliberately creates a new dedicated security group. If the existing VM currently uses the `default` security group, importing the VM alone will not automatically reconcile that existing security-group attachment.

## Debian 10 note

Debian 10 Buster is end-of-life. Use it only if this VM/application requires it. For a new production deployment, prefer a currently supported Debian release.

## Fixed IP note

This configuration requests `195.15.202.18` as the fixed IPv4 on `ext-net1`. The address must be available in that network/project. If the address is already attached to an existing VM, OpenStack will reject creation of another port/interface using it.
