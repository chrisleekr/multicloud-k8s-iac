resource "null_resource" "start_ingestion" {
  # Rerun when any doc changes (optional)
  triggers = {
    docs_hash = sha1(join(",", values(var.aws_s3_object_md)[*].etag))
    kb_id     = aws_bedrockagent_knowledge_base.knowledge_base.id
    ds_id     = aws_bedrockagent_data_source.s3.id
  }

  # https://docs.aws.amazon.com/cli/latest/reference/bedrock-agent/start-ingestion-job.html
  provisioner "local-exec" {
    command = <<EOT
aws bedrock-agent start-ingestion-job \
  --knowledge-base-id ${aws_bedrockagent_knowledge_base.knowledge_base.id} \
  --data-source-id ${aws_bedrockagent_data_source.s3.data_source_id} \
  --profile ${var.aws_profile} \
  --region ${var.aws_region}
EOT
  }
}
