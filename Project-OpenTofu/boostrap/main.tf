terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  #access_key = var.infomaniak_access_key
  #secret_key = var.infomaniak_secret_key

  endpoints {
    s3 = "https://s3.pub1.infomaniak.cloud"
  }

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  #s3_use_path_style = true
}

resource "aws_s3_bucket" "tofu_state" {
  bucket = var.bucket_name
}
