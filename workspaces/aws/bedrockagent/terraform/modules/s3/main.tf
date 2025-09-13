# https://avd.aquasec.com/misconfig/aws/s3/avd-aws-0132/#Terraform
resource "aws_kms_key" "knowledge_base_bucket_customer_managed_key" {
  enable_key_rotation = true
}

#tfsec:ignore:AVD-AWS-0089
resource "aws_s3_bucket" "knowledge_base_bucket" {
  bucket        = var.knowledge_base_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "knowledge_base_bucket" {
  bucket = aws_s3_bucket.knowledge_base_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "knowledge_base_bucket" {
  bucket = aws_s3_bucket.knowledge_base_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.knowledge_base_bucket_customer_managed_key.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "knowledge_base_bucket" {
  bucket                  = aws_s3_bucket.knowledge_base_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload all Markdown files from ./docs to S3
# (Place optional sidecars as filename.md.metadata.json in the same folder)
locals {
  md_files = fileset("${path.module}/../../../docs", "**/*.md")
}

resource "aws_s3_object" "md" {
  for_each     = { for f in local.md_files : f => f }
  bucket       = aws_s3_bucket.knowledge_base_bucket.id
  key          = each.key
  source       = "${path.module}/../../../docs/${each.key}"
  etag         = filemd5("${path.module}/../../../docs/${each.key}")
  content_type = "text/markdown"

  lifecycle {
    ignore_changes = [
      etag
    ]
  }
}
