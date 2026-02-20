#############################################################################################
# generate random id to create unique bucket id
#############################################################################################
resource "random_id" "bucket" {
  byte_length = 4
}

#############################################################################################
# creating deltalake root bucket
#############################################################################################
resource "aws_s3_bucket" "uc" {
  bucket = "dp-${var.environment}-uc-${random_id.bucket.hex}"
  force_destroy = true

  tags = {
    Purpose = "unity catalog"
    Env     = var.environment
  }
}

#############################################################################################
# block public access to unity catalog bucket 
#############################################################################################
resource "aws_s3_bucket_public_access_block" "uc" {
  bucket = aws_s3_bucket.uc.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#############################################################################################
# provide ownership as BucketOwnerPreferred from BucketOwnerEnforced
#############################################################################################
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.uc.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


#############################################################################################
# versioning of bucket
#############################################################################################
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.uc.id

  versioning_configuration {
    status = "Enabled"
  }
}

#############################################################################################
# default encryption applied on objects in bucket
#############################################################################################
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.uc.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
