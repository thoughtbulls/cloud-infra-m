#############################################################################################
# outputs of created resources which will be used in root outputs and other modules as input
#############################################################################################

output "datalake_bucket_name" {
  value = aws_s3_bucket.datalake_root.id
}

output "datalake_bucket_arn" {
  value = aws_s3_bucket.datalake_root.arn
}
