resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "workspace_root" {
  bucket = "dp-${var.environment}-workspace-root-${random_id.bucket.hex}"
  region = var.region
  force_destroy = true

  tags = {
    Purpose = "workspace-root"
    Env     = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.workspace_root.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "databricks_root_acl" {
  bucket = aws_s3_bucket.workspace_root.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.ownership
  ]
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.workspace_root.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.workspace_root.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
