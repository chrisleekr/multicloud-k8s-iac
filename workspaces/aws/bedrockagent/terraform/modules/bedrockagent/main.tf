resource "aws_bedrockagent_knowledge_base" "knowledge_base" {
  name     = "knowledge-base"
  role_arn = var.aws_iam_role_knowledge_base_execution_arn

  knowledge_base_configuration {
    type = "VECTOR"
    vector_knowledge_base_configuration {
      embedding_model_arn = var.aws_bedrock_foundation_model_embed_model_arn
    }
  }

  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = var.aws_opensearchserverless_collection_knowledge_base_arn
      vector_index_name = var.opensearch_index_knowledge_base_name
      field_mapping {
        vector_field   = "bedrock_vector"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }
}


resource "aws_bedrockagent_data_source" "s3" {
  knowledge_base_id = aws_bedrockagent_knowledge_base.knowledge_base.id
  name              = "knowledge-base-s3"
  data_source_configuration {
    type = "S3"
    s3_configuration {
      bucket_arn = var.aws_s3_bucket_knowledge_base_bucket_arn
    }
  }
}
