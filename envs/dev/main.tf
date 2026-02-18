module "network" {
  source = "../../modules/network"

  environment = var.environment
  region      = var.region

  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
}

module "workspace-storage" {
  source = "../../modules/workspace-storage"

  region = var.region
  environment = var.environment
}

module "datalake-storage" {
  source = "../../modules/datalake-storage"

  region = var.region
  environment = var.environment
}

module "iam" {
  source = "../../modules/iam"

  environment           = var.environment
  databricks_account_id = var.databricks_account_id
  workspace_bucket_arn  = module.workspace-storage.workspace_bucket_arn
}


module "databricks_workspace" {
  source = "../../modules/databricks-workspace"

  environment           = var.environment
  region                = var.region
  databricks_account_id = var.databricks_account_id

  bucket_name           = module.workspace-storage.workspace_bucket_name
  workspace_role_arn    = module.iam.workspace_role_arn
  storage_role_arn      = module.iam.storage_role_arn

  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  security_group_id     = module.network.security_group_id
  
}


