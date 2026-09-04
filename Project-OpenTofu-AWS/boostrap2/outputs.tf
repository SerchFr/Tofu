output "bucket_name" {
  description = "Name of the newly created bucket "
  value       = aws_s3_bucket.tofu_state.bucket
}

#output "bucket_endpoint" {
#  description = "S3 endpoint to use in the other project's backend config"
#  value       = "https://s3.pub1.infomaniak.cloud"
#}
