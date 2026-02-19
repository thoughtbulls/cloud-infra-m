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

################################################################################################
#  register cross-account workspace role's ARN. It provides rights to databricks account to 
#  access workspace infra in aws, -No need of databricks account id in new terraform version
################################################################################################
resource "databricks_mws_credentials" "this" {
  depends_on = [time_sleep.wait_for_iam]
  credentials_name = "dp-${var.environment}-credentials"
  role_arn         = var.workspace_role_arn
}

############################################################################
# register workspace root bucket storage with databricks account
# in this configuration no role's arn needed to register, there is
# one case if we want to use same workspace root bucket for unity-
# cataglog then it require to register storage_role_arn only. 
# never register workspace_role_arn
############################################################################
resource "databricks_mws_storage_configurations" "this" {
  depends_on = [time_sleep.wait_for_iam]
  account_id                  = var.databricks_account_id
  storage_configuration_name  = "dp-${var.environment}-workspace-storage"
  bucket_name                 = var.workspace_bucket_name

}

################################################################
# register VPC and other network infra with databricks account
################################################################
resource "databricks_mws_networks" "this" {
  account_id   = var.databricks_account_id
  network_name = "dp-${var.environment}-network"
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids
  security_group_ids = [var.security_group_id]

}

############################################################################################
#  create workspace in given VPC with workspace root bucket, credentials in a given region
############################################################################################
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
