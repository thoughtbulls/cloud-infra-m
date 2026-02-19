#############################################################################################
# inputs which require to create resources. they are passed from root module and others
#############################################################################################

variable "environment" {}
variable "region" {}
variable "databricks_account_id" {}

variable "workspace_bucket_name" {}
variable "workspace_bucket_arn" {}
variable "workspace_role_arn" {}

variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {}

variable "iam_dependency" {
  type = string
}

variable "databricks_account_root_arn" {
  
}


