module "s3" {
  source = "./modules/s3"

  knowledge_base_bucket_name = var.knowledge_base_bucket_name
}

module "iam" {
  source = "./modules/iam"
  depends_on = [
    module.s3
  ]

  aws_iam_role_path                       = var.aws_iam_role_path
  bedrock_foundation_model_embed_model_id = var.bedrock_foundation_model_embed_model_id
  aws_s3_bucket_knowledge_base_bucket_arn = module.s3.aws_s3_bucket_knowledge_base_bucket_arn
}

module "opensearch" {
  source = "./modules/opensearch"
  depends_on = [
    module.iam
  ]

  aws_iam_role_knowledge_base_execution_arn  = module.iam.aws_iam_role_knowledge_base_execution_arn
  aws_iam_role_knowledge_base_execution_name = module.iam.aws_iam_role_knowledge_base_execution_name
}

# Configure OpenSearch provider with dynamic endpoint for the index module
# This module requires to be separated from the opensearch module to prevent the circular dependency.
# It needs to be run after the collection is ready.
provider "opensearch" {
  alias       = "dynamic"
  aws_profile = var.aws_profile
  aws_region  = var.aws_region
  url         = module.opensearch.aws_opensearchserverless_collection_knowledge_base_collection_endpoint
  healthcheck = false
}

module "opensearch_index" {
  source = "./modules/opensearch_index"

  providers = {
    opensearch = opensearch.dynamic
  }
}

module "bedrockagent" {
  source = "./modules/bedrockagent"
  depends_on = [
    module.opensearch_index
  ]

  aws_profile = var.aws_profile
  aws_region  = var.aws_region

  aws_iam_role_knowledge_base_execution_arn = module.iam.aws_iam_role_knowledge_base_execution_arn

  aws_opensearchserverless_collection_knowledge_base_arn = module.opensearch.aws_opensearchserverless_collection_knowledge_base_arn
  opensearch_index_knowledge_base_name                   = module.opensearch_index.opensearch_index_knowledge_base_name

  aws_bedrock_foundation_model_embed_model_arn = module.iam.aws_bedrock_foundation_model_embed_model_arn

  aws_s3_bucket_knowledge_base_bucket_arn = module.s3.aws_s3_bucket_knowledge_base_bucket_arn

  aws_s3_object_md = module.s3.aws_s3_object_md
}
