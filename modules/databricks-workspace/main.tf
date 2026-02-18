#############################################
# Dependency bridge from IAM module
#############################################

locals {
  iam_dependency = var.iam_dependency
}


#############################################
# WAIT FOR IAM PROPAGATION
#############################################

resource "time_sleep" "wait_for_iam" {
  create_duration = "120s"
}

#  register cross-account ARN
resource "databricks_mws_credentials" "this" {
  depends_on = [time_sleep.wait_for_iam]
  # account_id       = var.databricks_account_id
  credentials_name = "dp-${var.environment}-credentials"
  role_arn         = var.workspace_role_arn
}

# register root bucket
resource "databricks_mws_storage_configurations" "this" {
  depends_on = [time_sleep.wait_for_iam]
  account_id                  = var.databricks_account_id
  storage_configuration_name  = "dp-${var.environment}-workspace-storage"
  bucket_name                 = var.workspace_bucket_name
  # role_arn                    = var.workspace_role_arn

}

# register VPC
resource "databricks_mws_networks" "this" {
  account_id   = var.databricks_account_id
  network_name = "dp-${var.environment}-network"
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids
  security_group_ids = [var.security_group_id]

}

#  create workspace in given VPC with DBFS on root bucket
resource "databricks_mws_workspaces" "workspace" {
  depends_on = [
    aws_s3_bucket_policy.workspace_root_policy,
    time_sleep.wait_for_iam
  ]

  account_id = var.databricks_account_id
  workspace_name = "dp-${var.environment}-workspace"
  aws_region = var.region

  credentials_id = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id = databricks_mws_networks.this.network_id
}
