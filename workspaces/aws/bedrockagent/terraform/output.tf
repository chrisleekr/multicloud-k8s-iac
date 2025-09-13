
output "md_files" {
  description = "MD files"
  value       = module.s3.md_files
}

output "aws_s3_bucket_knowledge_base_bucket_arn" {
  description = "ARN of the S3 bucket for the knowledge base"
  value       = module.s3.aws_s3_bucket_knowledge_base_bucket_arn
}

output "aws_bedrockagent_knowledge_base_arn" {
  description = "ARN of the Bedrock Agent knowledge base"
  value       = module.bedrockagent.aws_bedrockagent_knowledge_base_arn
}

output "aws_opensearchserverless_collection_knowledge_base_arn" {
  description = "ARN of the OpenSearch Serverless collection for the knowledge base"
  value       = module.opensearch.aws_opensearchserverless_collection_knowledge_base_arn
}

output "opensearch_index_knowledge_base_name" {
  description = "Name of the OpenSearch index for the knowledge base"
  value       = module.opensearch_index.opensearch_index_knowledge_base_name
}
