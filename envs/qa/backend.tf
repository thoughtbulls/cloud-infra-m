terraform {
  backend "s3" {
    bucket         = "dp-tf-state-763432567385"
    key            = "qa/cloud-infra/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
