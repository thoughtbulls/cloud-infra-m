#############################################################################################
# outputs of created resources which will be used in root outputs and other modules as input
#############################################################################################

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

output "security_group_id" {
  value = aws_security_group.databricks_sg.id
}

