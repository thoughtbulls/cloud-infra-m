output "bucket_name" {
  value = aws_s3_bucket.databricks_root.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.databricks_root.arn
}
