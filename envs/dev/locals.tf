locals {
  uc_storage_root = "s3://${module.datalake-storage.datalake_bucket_name}/uc-managed"
  workspace_id    = module.databricks_workspace.workspace_id
}