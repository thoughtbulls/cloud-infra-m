terraform {
  backend "s3" {
    bucket = "dp-tf-state-763432567385"
    key    = "bootstrap-metastore/ap-south-1/terraform.tfstate" # replace the region ap-south if you want other region
    region = "ap-south-1"
  }
}
