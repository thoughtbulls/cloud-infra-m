output "workspace_role_arn" {
  value = aws_iam_role.databricks_workspace_role.arn
}

output "storage_role_arn" {
  value = aws_iam_role.databricks_storage_role.arn
}

output "workspace_role_policy_attachment_id" {
  value = aws_iam_role_policy_attachment.workspace_role_attach_policy.id
}
