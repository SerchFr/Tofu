terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Infomaniak Public Cloud region, not a real AWS region

  access_key = var.infomaniak_access_key
  secret_key = var.infomaniak_secret_key

  endpoints {
    s3 = "https://s3.pub1.infomaniak.cloud"
  }

  # Required so the AWS provider doesn't try to behave like real AWS:
  skip_credentials_validation = true # don't call STS GetCallerIdentity (not supported)
  skip_requesting_account_id  = true # don't try to fetch an AWS account ID
  skip_metadata_api_check     = true # don't look for an EC2 instance metadata service
  skip_region_validation      = true # allow a non-AWS region name like "pub1"

  s3_use_path_style = true # Infomaniak needs path-style (endpoint/bucket), not virtual-hosted-style
}

resource "aws_s3_bucket" "tofu_state" {
  bucket = var.bucket_name
}
