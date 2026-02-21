#############################################################################################
# register all modules in root module
#############################################################################################

# network module
module "network" {
  source = "../../modules/network"

  environment = var.environment
  region      = var.region

  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
}

# workspace storage module
module "workspace-storage" {
  source = "../../modules/workspace-storage"

  region      = var.region
  environment = var.environment
}

# iam module
module "iam" {
  source = "../../modules/iam"

  environment = var.environment

  databricks_account_id       = var.databricks_account_id
  databricks_account_root_arn = var.databricks_account_root_arn

  workspace_bucket_arn = module.workspace-storage.workspace_bucket_arn
}

# databricks workspace module
module "databricks_workspace" {
  source         = "../../modules/databricks-workspace"
  
  iam_dependency = module.iam.workspace_role_policy_attachment_id

  environment                 = var.environment
  region                      = var.region
  databricks_account_id       = var.databricks_account_id
  databricks_account_root_arn = var.databricks_account_root_arn

  workspace_bucket_name = module.workspace-storage.workspace_bucket_name
  workspace_bucket_arn  = module.workspace-storage.workspace_bucket_arn

  workspace_role_arn = module.iam.workspace_role_arn

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  security_group_id  = module.network.security_group_id

}

module "metastore_assignment" {
  source = "../../modules/metastore-assignment"

  workspace_id = local.workspace_id
  metastore_id = local.metastore_id
}


