#############################################################################################
# generate random id to create unique bucket id
#############################################################################################
resource "random_id" "bucket" {
  byte_length = 4
}

#############################################################################################
# creating deltalake root bucket
#############################################################################################
resource "aws_s3_bucket" "datalake_root" {
  bucket = "dp-${var.environment}-datalake-root-${random_id.bucket.hex}"
  force_destroy = true

  tags = {
    Purpose = "datalake-root"
    Env     = var.environment
  }
}

#############################################################################################
# block public access to datalake bucket 
#############################################################################################
resource "aws_s3_bucket_public_access_block" "datalake_root" {
  bucket = aws_s3_bucket.datalake_root.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#############################################################################################
# provide ownership as BucketOwnerPreferred from BucketOwnerEnforced
#############################################################################################
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.datalake_root.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#############################################################################################
# provide access to write acls
#############################################################################################
resource "aws_s3_bucket_acl" "databricks_root_acl" {
  bucket = aws_s3_bucket.datalake_root.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.ownership
  ]
}

#############################################################################################
# versioning of bucket
#############################################################################################
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.datalake_root.id

  versioning_configuration {
    status = "Enabled"
  }
}

#############################################################################################
# default encryption applied on objects in bucket
#############################################################################################
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.datalake_root.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
