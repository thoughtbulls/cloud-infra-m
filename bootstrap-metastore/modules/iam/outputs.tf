#############################################################################################
# outputs of created resources which will be used in root outputs and other modules as input
#############################################################################################


output "uc_storage_role_arn" {
  value = aws_iam_role.uc_storage_role.arn
}

