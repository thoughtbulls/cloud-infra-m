###############################################################
# workspace bucket policy to allow databricks account root
###############################################################

resource "aws_s3_bucket_policy" "workspace_root_policy" {
  bucket = var.workspace_bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.databricks_account_root_arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:PutObjectAcl"
        ]
        Resource = [
          var.workspace_bucket_arn,
          "${var.workspace_bucket_arn}/*"
        ]
      }
    ]
  })
}
