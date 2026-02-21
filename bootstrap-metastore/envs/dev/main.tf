module "storage" {
  source = "../../modules/storage"

  region      = var.region
  environment = var.environment
}

module "iam" {
  source = "../../modules/iam"

  environment = var.environment

  databricks_account_id       = var.databricks_account_id
  databricks_account_root_arn = var.databricks_account_root_arn

  uc_bucket_arn = module.storage.uc_bucket_arn
}

module "metastore" {
  source = "../../modules/metastore"

  metastore_name = "${var.metastore_name}-${var.region}"
  storage_root   = "s3://${module.storage.uc_bucket_name}/uc-managed"
  region         = var.region

  providers = {
    databricks = databricks.account
  }
}
