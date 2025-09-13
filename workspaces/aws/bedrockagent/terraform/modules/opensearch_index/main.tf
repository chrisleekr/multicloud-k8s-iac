# https://registry.terraform.io/providers/opensearch-project/opensearch/latest/docs/resources/index
# https://aws.amazon.com/blogs/machine-learning/amazon-bedrock-knowledge-bases-now-supports-amazon-opensearch-service-managed-cluster-as-vector-store/
# https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-setup.html
resource "opensearch_index" "knowledge_base" {
  name = "knowledge-base"

  index_knn          = true
  number_of_shards   = 2
  number_of_replicas = 0
  rollover_alias     = "knowledge-base"

  mappings = jsonencode({
    properties = {
      AMAZON_BEDROCK_TEXT_CHUNK = {
        type = "text",
        # index = true
      },
      AMAZON_BEDROCK_METADATA = {
        type  = "text",
        index = false
      },
      bedrock_vector = {
        type      = "knn_vector"
        dimension = var.vector_dimension

        method = {
          name       = "hnsw",
          engine     = "faiss",
          space_type = "l2",
          parameters = {
            ef_construction = 128,
            m               = 24
          }
        }
      },
      id = {
        type = "text",
        fields = {
          keyword = {
            type         = "keyword",
            ignore_above = 256
          }
        }
      },
      "x-amz-bedrock-kb-data-source-id" = {
        type = "text",
        fields = {
          keyword = {
            type         = "keyword",
            ignore_above = 256
          }
        }
      },
      "x-amz-bedrock-kb-source-uri" = {
        type = "text",
        fields = {
          keyword = {
            type         = "keyword",
            ignore_above = 256
          }
        }
      }
    }
  })

  force_destroy = true
}
