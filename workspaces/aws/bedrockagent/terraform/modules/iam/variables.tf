variable "aws_iam_role_path" {
  description = "Path for the IAM role"
  type        = string
}

variable "bedrock_foundation_model_embed_model_id" {
  description = "Bedrock foundation model embed model ID"
  type        = string
}

variable "aws_s3_bucket_knowledge_base_bucket_arn" {
  description = "ARN of the S3 bucket for the knowledge base"
  type        = string
}
