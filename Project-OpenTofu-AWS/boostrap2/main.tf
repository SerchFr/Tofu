terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3" 
}

resource "aws_s3_bucket" "tofu_state" {
  bucket = var.bucket_name
}

# Recommandé sur AWS : versioning pour pouvoir restaurer un
# ancien state en cas de corruption/erreur.
resource "aws_s3_bucket_versioning" "tofu_state" {
  bucket = aws_s3_bucket.tofu_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bloque tout accès public au bucket de state (bonne pratique,
# le state contient potentiellement des secrets/IPs).
#resource "aws_s3_bucket_public_access_block" "tofu_state" {
#  bucket                  = aws_s3_bucket.tofu_state.id
#  block_public_acls       = true
#  block_public_policy     = true
#  ignore_public_acls      = true
#  restrict_public_buckets = true
#}
