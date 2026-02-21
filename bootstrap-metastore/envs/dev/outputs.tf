output "metastore_id" {
  value = module.metastore.metastore_id
}

output "uc_storage_role_arn" {
  value = module.iam.uc_storage_role_arn
}
