data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    bucket = "dp-tf-state-763432567385"
    key    = "bootstrap-metastore/ap-south-1/terraform.tfstate"
    region = "ap-south-1"
  }
}