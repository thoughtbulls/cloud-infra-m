output "databricks_root_bucket" {
  value = aws_s3_bucket.databricks_root.bucket
}

output "databricks_root_bucket_arn" {
  value = aws_s3_bucket.databricks_root.arn
}



