locals {
  metastore_id = data.terraform_remote_state.bootstrap.outputs.metastore_id
  workspace_id = module.databricks_workspace.workspace_id
}