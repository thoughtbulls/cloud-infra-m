#############################################################################################
# register terraform state key with terraform state bucket
#############################################################################################

terraform {
  backend "s3" {
    bucket         = "dp-tf-state-763432567385"
    key            = "dev/cloud-infra/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
