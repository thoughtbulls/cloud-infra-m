module "network" {
  source = "../../modules/network"

  environment = var.environment
  region      = var.region

  vpc_cidr              = "10.20.0.0/16"
  public_subnet_cidr    = "10.20.1.0/24"
  private_subnet_a_cidr = "10.20.11.0/24"
  private_subnet_b_cidr = "10.20.12.0/24"
}

module "storage" {
  source = "../../modules/storage"

  region = var.region
  environment = var.environment
}

module "iam" {
  source = "../../modules/iam"

  environment           = var.environment
  databricks_account_id = var.databricks_account_id
  bucket_arn            = module.storage.bucket_arn
}

module "databricks_workspace" {
  source = "../../modules/databricks-workspace"

  environment           = var.environment
  region                = var.region
  databricks_account_id = var.databricks_account_id

  bucket_name           = module.storage.bucket_name
  mws_role_arn          = module.iam.mws_role_arn

  vpc_id                = module.network.vpc_id
  private_subnet_ids    = module.network.private_subnet_ids
  security_group_id     = module.network.security_group_id
}


