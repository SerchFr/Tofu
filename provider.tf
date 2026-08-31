# Infomaniak Public Cloud / OpenStack provider.
#
# Recommended: authenticate with an OpenStack clouds.yaml/openrc environment
# rather than putting credentials in this file.
#
# For example, source your Infomaniak openrc.sh before running:
#   source ./openrc.sh
#
# The provider will then use OS_AUTH_URL, OS_USERNAME, OS_PASSWORD,
# OS_PROJECT_NAME/OS_TENANT_NAME, OS_REGION_NAME, etc.

provider "openstack" {
  auth_url = var.auth_url
  region   = var.region
}
