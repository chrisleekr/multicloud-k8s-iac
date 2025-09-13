resource "aws_iam_role_policy" "knowledge_base_opensearchserverless" {
  name = "knowledge-base-opensearchserverless"
  role = var.aws_iam_role_knowledge_base_execution_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "aoss:APIAccessAll",
          "aoss:ListCollections",
          "aoss:DescribeCollectionItems"
        ]
        Resource = aws_opensearchserverless_collection.knowledge_base.arn
      }
    ]
  })
}
