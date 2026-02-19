#############################################################################################
# using specifically terraforms's databricks provider to create databricks resources 
#############################################################################################
terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}
