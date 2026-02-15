output "mws_role_arn" {
  value = aws_iam_role.databricks_role.arn
}

output "cluster_role_arn" {
  value = aws_iam_role.databricks_storage_role.arn
}
