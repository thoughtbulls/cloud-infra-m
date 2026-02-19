#############################################################################################
# Storage datalake IAM ROLES
#############################################################################################
resource "aws_iam_role" "databricks_storage_role" {
  name = "dp-${var.environment}-databricks-storage-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.databricks_account_root_arn
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.databricks_account_id
          }
        }
      }
    ]
  })
}