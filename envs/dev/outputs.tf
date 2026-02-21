#############################################################################################
# outputs of created resources which which will be exposed to monitor of state
#############################################################################################
output "workspace_role_arn" {
  value = module.iam.workspace_role_arn
}


output "workspace_bucket_name" {
  value = module.workspace-storage.workspace_bucket_name
}


output "vpc_id" {
  value = module.network.vpc_id
}

output "workspace_url" {
  value = module.databricks_workspace.workspace_url
}

output "workspace_id" {
  value = module.databricks_workspace.workspace_id
}

output "metastore_id" {
  value = local.metastore_id
}
