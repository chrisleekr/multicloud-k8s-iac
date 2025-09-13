output "aws_opensearchserverless_collection_knowledge_base_arn" {
  description = "ARN of the OpenSearch Serverless collection for the knowledge base"
  value       = aws_opensearchserverless_collection.knowledge_base.arn
}

output "aws_opensearchserverless_collection_knowledge_base_collection_endpoint" {
  description = "Endpoint of the OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.knowledge_base.collection_endpoint
}
