### modules/storage/main.tf ###

# CREATING AND CONFIGURING EFS FILE SYSTEM
resource "aws_efs_file_system" "efs_token" {
  creation_token   = "${var.project}-${var.environment}-efs"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted        = true

  tags = {
    Name        = "${var.project}-${var.environment}-efs"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

data "aws_iam_policy_document" "efs_policy" {
  statement {
    sid    = "EFS Policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "elasticfilesystem:ClientRootAccess",
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
    ]

    resources = [aws_efs_file_system.efs_token.arn]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}

resource "aws_efs_file_system_policy" "efs_system_policy" {
  file_system_id = aws_efs_file_system.efs_token.id
  policy         = data.aws_iam_policy_document.efs_policy.json
}

resource "aws_efs_backup_policy" "efs_backup_policy" {
  file_system_id = aws_efs_file_system.efs_token.id

  backup_policy {
    status = "ENABLED"
  }
}

# CREATING AND CONFIGURING THE SUBNET CONNECTION
resource "aws_efs_mount_target" "efs_mount_target" {
  count           = length(var.subnets)
  file_system_id  = aws_efs_file_system.efs_token.id
  subnet_id       = var.subnets[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}

# CREATING AND CONFIGURING EFS SECURITY GROUP
resource "aws_security_group" "efs_sg" {
  name        = "${var.project}-${var.environment}-efs-sg"
  description = "Security group for Amazon EFS"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}