resource "aws_iam_role" "databricks_role" {
  name = "dp-${var.environment}-databricks-role"

  assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::414351767826:root"
      }
      Action = "sts:AssumeRole"
      Condition = {
        StringEquals = {
          "sts:ExternalId" = var.databricks_account_id
          }
        }
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "ec2_access" {
  role       = aws_iam_role.databricks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role" "databricks_storage_role" {
  name = "dp-${var.environment}-databricks-storage-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::414351767826:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.databricks_account_id
          }
        }
      }
    ]
  })
}


resource "aws_iam_policy" "databricks_storage_policy" {
  name = "dp-${var.environment}-databricks-storage-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = var.bucket_arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${var.bucket_arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.databricks_storage_role.name
  policy_arn = aws_iam_policy.databricks_storage_policy.arn
}