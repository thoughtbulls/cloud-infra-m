#############################################################################################
# outputs of created resources which will be used in root outputs and other modules as input
#############################################################################################

output "uc_bucket_name" {
  value = aws_s3_bucket.uc.id
}

output "uc_bucket_arn" {
  value = aws_s3_bucket.uc.arn
}
