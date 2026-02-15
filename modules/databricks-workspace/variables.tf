variable "environment" {}
variable "region" {}
variable "databricks_account_id" {}

variable "bucket_name" {}
variable "mws_role_arn" {}

variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {}
