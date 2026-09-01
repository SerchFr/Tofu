variable "infomaniak_access_key" {
  description = "Infomaniak S3 access key (the 'Access' value from `openstack ec2 credentials list`)"
  type        = string
  sensitive   = true
}

variable "infomaniak_secret_key" {
  description = "Infomaniak S3 secret key (the 'Secret' value from `openstack ec2 credentials list`)"
  type        = string
  sensitive   = true
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create (must be lowercase, no underscores)"
  type        = string
}
