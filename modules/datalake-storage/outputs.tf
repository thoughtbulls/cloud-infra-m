output "datalake_bucket_name" {
  value = aws_s3_bucket.datalake_root.id
}

output "datalake_bucket_arn" {
  value = aws_s3_bucket.datalake_root.arn
}
