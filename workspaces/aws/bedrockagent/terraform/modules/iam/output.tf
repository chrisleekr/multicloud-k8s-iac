output "aws_iam_role_knowledge_base_execution_arn" {
  description = "ARN of the IAM role for the knowledge base execution"
  value       = aws_iam_role.knowledge_base_execution.arn
}

output "aws_iam_role_knowledge_base_execution_name" {
  description = "Name of the IAM role for the knowledge base execution"
  value       = aws_iam_role.knowledge_base_execution.name
}

output "aws_bedrock_foundation_model_embed_model_arn" {
  description = "ARN of the Bedrock foundation model embed model"
  value       = data.aws_bedrock_foundation_model.embed.model_arn
}
