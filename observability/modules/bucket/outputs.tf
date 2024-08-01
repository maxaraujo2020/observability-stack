### modules/bucket/outputs.tf ###

output "bucket_s3" {
  value = aws_s3_bucket.bucket_observability.bucket
}
