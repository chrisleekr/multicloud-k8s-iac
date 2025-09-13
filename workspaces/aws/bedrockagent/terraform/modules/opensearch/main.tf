# Add this data source to get current AWS identity
data "aws_caller_identity" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_collection
resource "aws_opensearchserverless_collection" "knowledge_base" {
  name = "knowledge-base"
  type = "VECTORSEARCH"
  depends_on = [
    aws_opensearchserverless_security_policy.encryption,
    aws_opensearchserverless_security_policy.network,
    aws_opensearchserverless_access_policy.data
  ]
}
