variable "aws_profile" {
  description = "AWS profile"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_bedrock_foundation_model_embed_model_arn" {
  description = "ARN of the Bedrock foundation model embed model"
  type        = string
}

variable "aws_iam_role_knowledge_base_execution_arn" {
  description = "ARN of the IAM role for the knowledge base execution"
  type        = string
}

variable "aws_opensearchserverless_collection_knowledge_base_arn" {
  description = "ARN of the OpenSearch Serverless collection for the knowledge base"
  type        = string
}

variable "opensearch_index_knowledge_base_name" {
  description = "Name of the OpenSearch index for the knowledge base"
  type        = string
}

variable "aws_s3_bucket_knowledge_base_bucket_arn" {
  description = "ARN of the S3 bucket for the knowledge base"
  type        = string
}


variable "aws_s3_object_md" {
  description = "AWS S3 object for the MD files"
  type        = map(any)
}
