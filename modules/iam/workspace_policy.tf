#############################################################################################
# Workspace IAM Policy
#############################################################################################
resource "aws_iam_policy" "databricks_workspace_policy" {
  name = "dp-${var.environment}-databricks-workspace-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "iam:PassRole",
        "s3:*",
        "logs:*"
      ],
      "Resource": "*"
    }

    ]
  })
}


########################################
# Storage role and policy attachment
########################################
resource "aws_iam_role_policy_attachment" "workspace_role_attach_policy" {
  role       = aws_iam_role.databricks_workspace_role.name
  policy_arn = aws_iam_policy.databricks_workspace_policy.arn
}