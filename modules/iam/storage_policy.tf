########################################
# Storage datalake IAM Policy
########################################
resource "aws_iam_policy" "databricks_storage_policy" {
  name = "dp-${var.environment}-databricks-storage-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = var.datalake_bucket_arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${var.datalake_bucket_arn}/*"
      }
    ]
  })
}

########################################
# Storage role and policy attachment
########################################
resource "aws_iam_role_policy_attachment" "storage_role_attach_policy" {
  role       = aws_iam_role.databricks_storage_role.name
  policy_arn = aws_iam_policy.databricks_storage_policy.arn
}