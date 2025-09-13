output "aws_bedrockagent_knowledge_base_arn" {
  description = "ARN of the Bedrock Agent knowledge base"
  value       = aws_bedrockagent_knowledge_base.knowledge_base.arn
}

output "aws_bedrockagent_data_source_id" {
  description = "ID of the Bedrock Agent data source"
  value       = aws_bedrockagent_data_source.s3.id
}
