### modules/bucket/main.tf ###

# CREATING AND CONFIGURING S3 KEY ON KMS 
resource "aws_kms_key" "kms_s3_key" {
    description             = "Key to protect S3 objects"
    key_usage               = "ENCRYPT_DECRYPT"
    deletion_window_in_days = 7
    is_enabled              = true
}

resource "aws_kms_alias" "kms_s3_key_alias" {
    name          = "alias/s3-key"
    target_key_id = aws_kms_key.kms_s3_key.key_id
}

###############################################################
# CREATING AND CONFIGURING MAIN S3 BUCKET
resource "aws_s3_bucket" "bucket_observability" {
  bucket = "${var.project}-${var.environment}-s3"
  
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "${var.project}-${var.environment}-observability-s3"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_s3_bucket_acl" "bucket_permission" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership
  ]
  bucket = aws_s3_bucket.bucket_observability.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning_s3" {
  bucket = aws_s3_bucket.bucket_observability.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_logging" "bucket_s3_logging" {
  bucket = aws_s3_bucket.bucket_observability.id

  target_bucket = aws_s3_bucket.bucket_observability.bucket
  target_prefix = "${aws_s3_bucket.bucket_observability.bucket}/"
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.bucket_observability.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3 Bucket Policy",
            "Effect": "Allow",
            "Principal": {"AWS":"arn:aws:iam::300012770768:root"},
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "${aws_s3_bucket.bucket_observability.arn}/*"
            ]
        }
    ]
  })
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.bucket_observability.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

###############################################################
# CREATING AND CONFIGURING VERSIONING PERMISSIONS
# resource "aws_s3_bucket_policy" "s3_bucket_policy_versioning" {
#   bucket = "${var.tfstate_bucket}"
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "S3 TFState Bucket Policy",
#             "Effect": "Allow",
#             "Principal": {"AWS":"arn:aws:iam::300012770768:root"},
#             "Action": [
#                 "s3:GetObject"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::${var.tfstate_bucket}/*"                
#             ]
#         }
#     ]
#   })
# }
