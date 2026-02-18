output "datalake_bucket_name" {
  value = aws_s3_bucket.datalake_root.bucket
}

output "datalake_bucket_arn" {
  value = aws_s3_bucket.datalake_root.arn
}
