#############################################################################################
# register aws and databricks providers with region
#############################################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.30"
    }

    time = {
      source = "hashicorp/time"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "databricks" {
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
}