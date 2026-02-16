########################################
# DATA SOURCES
########################################

data "aws_caller_identity" "current" {}

########################################
# IAM ROLES
########################################
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

resource "aws_iam_policy" "databricks_workspace_policy" {
  name = "dp-${var.environment}-databricks-workspace-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # EC2 lifecycle for clusters
      {
        Effect = "Allow"
        Action = [
          "ec2:AllocateAddress",
          "ec2:AssignPrivateIpAddresses",
          "ec2:AssociateDhcpOptions",
          "ec2:AssociateIamInstanceProfile",
          "ec2:AssociateRouteTable",
          "ec2:AttachInternetGateway",
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CancelSpotInstanceRequests",
          "ec2:CreateDhcpOptions",
          "ec2:CreateFleet",
          "ec2:CreateInternetGateway",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:CreateNatGateway",
          "ec2:CreateRoute",
          "ec2:CreateRouteTable",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSubnet",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:CreateVpc",
          "ec2:CreateVpcEndpoint",
          "ec2:DeleteDhcpOptions",
          "ec2:DeleteFleets",
          "ec2:DeleteInternetGateway",
          "ec2:DeleteLaunchTemplate",
          "ec2:DeleteLaunchTemplateVersions",
          "ec2:DeleteNatGateway",
          "ec2:DeleteRoute",
          "ec2:DeleteRouteTable",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSubnet",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DeleteVpc",
          "ec2:DeleteVpcEndpoints",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeFleetHistory",
          "ec2:DescribeFleetInstances",
          "ec2:DescribeFleets",
          "ec2:DescribeIamInstanceProfileAssociations",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstances",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeNatGateways",
          "ec2:DescribePrefixLists",
          "ec2:DescribeReservedInstancesOfferings",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSpotInstanceRequests",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:DescribeVpcs",
          "ec2:DetachInternetGateway",
          "ec2:DisassociateIamInstanceProfile",
          "ec2:DisassociateRouteTable",
          "ec2:GetLaunchTemplateData",
          "ec2:GetSpotPlacementScores",
          "ec2:ModifyFleet",
          "ec2:ModifyLaunchTemplate",
          "ec2:ModifyVpcAttribute",
          "ec2:ReleaseAddress",
          "ec2:ReplaceIamInstanceProfileAssociation",
          "ec2:RequestSpotInstances",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
        ]
        Resource = "*"
      },

      # Networking
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces"
        ]
        Resource = "*"
      },

      # Required by Databricks
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = "*"
      },

      # Service linked role
      {
        Effect = "Allow"
        Action = [
          "iam:CreateServiceLinkedRole"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "workspace_role_attach_policy" {
  role       = aws_iam_role.databricks_role.name
  policy_arn = aws_iam_policy.databricks_workspace_policy.arn
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
      },
      {
        Sid = "SelfAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::414351767826:root"
        }
        Action = "sts:AssumeRole"
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
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
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

resource "aws_iam_role_policy_attachment" "storage_role_attach_policy" {
  role       = aws_iam_role.databricks_storage_role.name
  policy_arn = aws_iam_policy.databricks_storage_policy.arn
}
