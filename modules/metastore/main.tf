resource "databricks_metastore" "this" {
  name          = var.metastore_name
  storage_root  = var.storage_root
  region        = var.region
  force_destroy = true
}
