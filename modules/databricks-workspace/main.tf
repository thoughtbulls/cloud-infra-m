resource "databricks_mws_storage_configurations" "this" {
  account_id                  = var.databricks_account_id
  storage_configuration_name  = "dp-${var.environment}-storage"
  bucket_name                 = var.bucket_name
  role_arn                    = var.storage_role_arn

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}


resource "databricks_mws_credentials" "this" {
  credentials_name = "dp-${var.environment}-credentials"
  role_arn         = var.workspace_role_arn

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}


resource "databricks_mws_networks" "this" {
  account_id   = var.databricks_account_id
  network_name = "dp-${var.environment}-network"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  security_group_ids = [
    var.security_group_id
  ]

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}


resource "time_sleep" "wait_for_iam" {
  create_duration = "90s"

  depends_on = [
    data.terraform_
  ]
}

resource "databricks_mws_workspaces" "workspace" {

  depends_on = [
    time_sleep.wait_for_iam
  ]

  account_id = var.databricks_account_id
  workspace_name = "dp-${var.environment}-workspace"
  aws_region = var.region

  credentials_id = databricks_mws_credentials.this.credentials_id
  network_id = databricks_mws_networks.this.network_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id

  lifecycle {
  prevent_destroy = var.prevent_destroy

  ignore_changes = [
    workspace_url,
    deployment_name
    ]
  }
}
