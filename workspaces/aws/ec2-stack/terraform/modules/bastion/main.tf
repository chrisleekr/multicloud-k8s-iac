# Get current AWS region
data "aws_region" "current" {}

# Define local values
locals {
  bastion_user_data_script = <<-EOF
#!/bin/bash
# Install essential packages only
sudo yum install -y openssh-server amazon-ssm-agent jq
sudo systemctl enable sshd amazon-ssm-agent
sudo systemctl start sshd amazon-ssm-agent

# Install AWS CLI (required for secrets access)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -f awscliv2.zip
rm -rf aws/

# Create .ssh directory for ec2-user and set permissions
sudo -u ec2-user mkdir -p /home/ec2-user/.ssh
sudo chmod 700 /home/ec2-user/.ssh

# Get the SSH key and save it with proper ownership
aws secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.ssh_key.name} --region ${data.aws_region.current.region} | jq -r .SecretString | sudo tee /home/ec2-user/.ssh/id_rsa > /dev/null
sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/id_rsa
sudo chmod 600 /home/ec2-user/.ssh/id_rsa

EOF
}

# Resource to track user data changes
resource "null_resource" "bastion_user_data_tracker" {
  triggers = {
    user_data_sha1 = sha1(local.bastion_user_data_script)
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "bastion" {
  key_name   = "${var.environment}-bastion-key"
  public_key = tls_private_key.ssh.public_key_openssh
}


# Create an IAM role for the bastion host
resource "aws_iam_role" "bastion" {
  name = "${var.environment}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


# Attach the AmazonSSMManagedInstanceCore policy to allow SSM Session Manager
resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an instance profile for the bastion host
resource "aws_iam_instance_profile" "bastion" {
  name = "${var.environment}-bastion-profile"
  role = aws_iam_role.bastion.name
}

# Generate random suffix for the secret name
resource "random_string" "secret_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Store the SSH private key in AWS Secrets Manager
# trivy:ignore:AVD-AWS-0098 (LOW): Secret explicitly uses the default key.
resource "aws_secretsmanager_secret" "ssh_key" {
  name = "${var.environment}/bastion/ssh-key-${random_string.secret_suffix.result}"
}

resource "aws_secretsmanager_secret_version" "ssh_key" {
  secret_id     = aws_secretsmanager_secret.ssh_key.id
  secret_string = tls_private_key.ssh.private_key_pem
}

# Create an IAM policy for Secrets Manager access
resource "aws_iam_policy" "secrets_access" {
  name = "${var.environment}-bastion-secrets-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [aws_secretsmanager_secret.ssh_key.arn]
      }
    ]
  })
}

# Attach the Secrets Manager policy to the bastion role
resource "aws_iam_role_policy_attachment" "bastion_secrets" {
  role       = aws_iam_role.bastion.name
  policy_arn = aws_iam_policy.secrets_access.arn
}


resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.bastion.key_name

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion.name

  root_block_device {
    encrypted = true # AVD-AWS-0131 (HIGH): Root block device is not encrypted.
  }

  metadata_options {
    http_tokens   = "required" # AVD-AWS-0028 (HIGH): Instance does not require IMDS access to require a token.
    http_endpoint = "enabled"
  }

  user_data = local.bastion_user_data_script

  tags = merge(
    var.tags,
    {
      Name    = "${var.environment}-${var.instance_name}"
      Bastion = "true"
    }
  )

  # Force replacement when user_data changes
  lifecycle {
    replace_triggered_by = [null_resource.bastion_user_data_tracker.id]
  }
}
