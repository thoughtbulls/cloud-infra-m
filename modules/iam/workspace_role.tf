#############################################################################################
# Workspace IAM ROLES
#############################################################################################

data "aws_caller_identity" "current" {}


resource "aws_iam_role" "databricks_workspace_role" {
  name = "dp-${var.environment}-databricks-workspace-role"

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