output "workspace_role_arn" {
  value = module.iam.workspace_role_arn
}

output "storage_role_arn" {
  value = module.iam.storage_role_arn
}

output "workspace_bucket_name" {
  value = module.workspace-storage.workspace_bucket_name
}

output "datalake_bucket_name" {
  value = module.datalake-storage.datalake_bucket_name
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "workspace_url" {
  value = module.databricks_workspace.workspace_url
}
