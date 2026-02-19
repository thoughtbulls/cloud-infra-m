#############################################################################################
# generate random id to create unique bucket id
#############################################################################################
resource "random_id" "bucket" {
  byte_length = 4
}

#############################################################################################
# creating workspace root bucket
#############################################################################################
resource "aws_s3_bucket" "workspace_root" {
  bucket = "dp-${var.environment}-workspace-root-${random_id.bucket.hex}"
  force_destroy = true

  tags = {
    Purpose = "workspace-root"
    Env     = var.environment
  }
}

#############################################################################################
# block public access to workspace bucket 
#############################################################################################
resource "aws_s3_bucket_public_access_block" "workspace_root" {
  bucket = aws_s3_bucket.workspace_root.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#############################################################################################
# provide ownership as BucketOwnerPreferred from BucketOwnerEnforced
#############################################################################################
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.workspace_root.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#############################################################################################
# versioning of bucket
#############################################################################################
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.workspace_root.id

  versioning_configuration {
    status = "Disabled"
  }
}

#############################################################################################
# default encryption applied on objects in bucket
#############################################################################################
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.workspace_root.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
