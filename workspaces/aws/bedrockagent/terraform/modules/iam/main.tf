data "aws_bedrock_foundation_model" "embed" {
  model_id = var.bedrock_foundation_model_embed_model_id
}

resource "aws_iam_role" "knowledge_base_execution" {
  name = "knowledge-base-execution"
  path = var.aws_iam_role_path
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "bedrock.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "knowledge_base_invoke" {
  name = "knowledge-base-invoke"
  role = aws_iam_role.knowledge_base_execution.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["bedrock:InvokeModel"]
      Resource = data.aws_bedrock_foundation_model.embed.model_arn
    }]
  })
}


resource "aws_iam_role_policy" "knowledge_base_s3" {
  name = "knowledge-base-s3"
  role = aws_iam_role.knowledge_base_execution.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:ListBucket",
        Resource = var.aws_s3_bucket_knowledge_base_bucket_arn
      },
      {
        Effect   = "Allow",
        Action   = "s3:GetObject",
        Resource = "${var.aws_s3_bucket_knowledge_base_bucket_arn}/*"
      }
    ]
  })
}
