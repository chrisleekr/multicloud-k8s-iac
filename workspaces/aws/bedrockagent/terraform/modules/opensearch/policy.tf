
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearchserverless_security_policy
resource "aws_opensearchserverless_security_policy" "encryption" {
  name = "knowledge-base-encryption-policy"
  type = "encryption"
  # https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-encryption.html
  policy = jsonencode({
    Rules = [
      {
        Resource     = ["collection/knowledge-base"],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })
}


resource "aws_opensearchserverless_security_policy" "network" {
  name = "knowledge-base-network-policy"
  type = "network"
  # https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-network.html
  policy = jsonencode([
    {
      Description = "Public access to collection and Dashboards endpoint for example collection",
      Rules = [
        {
          ResourceType = "collection",
          Resource     = ["collection/knowledge-base"]
        },
        {
          ResourceType = "dashboard",
          Resource     = ["collection/knowledge-base"]
        }
      ],
      AllowFromPublic = true # Not recommended for production.
      # SourceVPCEs     = [<VPC_ENDPOINT_ID>]
    }
  ])
}

# https://docs.aws.amazon.com/bedrock/latest/userguide/kb-create-security.html
resource "aws_opensearchserverless_access_policy" "data" {
  name = "knowledge-base-data-policy"
  type = "data"
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "index"
          Resource = [
            "index/knowledge-base/*"
          ]
          Permission = [
            "aoss:CreateIndex",
            "aoss:DeleteIndex",
            "aoss:DescribeIndex",
            "aoss:ReadDocument",
            "aoss:UpdateIndex",
            "aoss:WriteDocument",
          ]
        },
        {
          ResourceType = "collection"
          Resource = [
            "collection/knowledge-base"
          ]
          Permission = [
            "aoss:CreateCollectionItems",
            "aoss:DeleteCollectionItems",
            "aoss:DescribeCollectionItems",
            "aoss:UpdateCollectionItems"
          ]
        }
      ],
      Principal = [
        var.aws_iam_role_knowledge_base_execution_arn,
        data.aws_caller_identity.current.arn # Not recommended for production. Add current AWS identity to the principal to allow the role to access the collection.
      ]
    }
  ])
}
