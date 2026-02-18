resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "datalake_root" {
  bucket = "dp-${var.environment}-datalake-root-${random_id.bucket.hex}"
  force_destroy = var.environment != "prod"

  tags = {
    Purpose = "datalake-root"
    Env     = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "datalake_root" {
  bucket = aws_s3_bucket.datalake_root.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.datalake_root.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "databricks_root_acl" {
  bucket = aws_s3_bucket.datalake_root.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.ownership
  ]
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.datalake_root.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.datalake_root.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
