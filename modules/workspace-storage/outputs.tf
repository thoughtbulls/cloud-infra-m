output "workspace_bucket_name" {
  value = aws_s3_bucket.workspace_root.bucket
}

output "workspace_bucket_arn" {
  value = aws_s3_bucket.workspace_root.arn
}
