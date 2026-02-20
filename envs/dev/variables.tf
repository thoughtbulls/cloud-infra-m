#############################################################################################
# inputs which require to create resources. they are passed from root module and others
#############################################################################################
variable "environment" {}
variable "region" {}

variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_a_cidr" {}
variable "private_subnet_b_cidr" {}

variable "databricks_account_id" {}
variable "databricks_account_root_arn" {
  description = "Databricks AWS account root ARN"
  type        = string
}

variable "metastore_name" {}
