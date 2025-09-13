variable "aws_profile" {
  description = "AWS profile"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "knowledge_base_bucket_name" {
  description = "S3 bucket name for knowledge base"
  type        = string
  default     = "sample-bedrockagent-kb-docs"
}

variable "aws_iam_role_path" {
  description = "Path for the IAM role"
  type        = string
}

variable "bedrock_foundation_model_embed_model_id" {
  description = "Bedrock foundation model embed model ID"
  type        = string
  default     = "amazon.titan-embed-text-v2:0"
}
