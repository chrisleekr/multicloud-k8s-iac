output "aws_s3_bucket_knowledge_base_bucket_arn" {
  description = "ARN of the S3 bucket for the knowledge base"
  value       = aws_s3_bucket.knowledge_base_bucket.arn
}


output "aws_s3_object_md" {
  description = "AWS S3 object for the MD files"
  value       = aws_s3_object.md
}

output "md_files" {
  description = "MD files"
  value       = local.md_files
}
