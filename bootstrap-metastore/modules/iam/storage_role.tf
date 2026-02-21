#############################################################################################
# Storage unity catalog IAM ROLES
#############################################################################################
resource "aws_iam_role" "uc_storage_role" {
  name = "dp-${var.environment}-uc-storage-role"

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