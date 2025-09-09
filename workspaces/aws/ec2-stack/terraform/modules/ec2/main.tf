locals {
  ec2_user_data_script = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd

              # Set timezone to Australia/Sydney
              sudo timedatectl set-timezone Australia/Sydney

              # Download the test file
              echo "Hello, World!" > /var/www/html/index.html

              sudo systemctl enable httpd
              sudo systemctl start httpd

              echo "User data script completed" > /var/www/html/user-data-complete.html
              EOF
}

# Resource to track user data changes
resource "null_resource" "ec2_user_data_tracker" {
  triggers = {
    user_data_sha1 = sha1(local.ec2_user_data_script)
  }
}

resource "aws_instance" "web" {
  count         = length(var.subnet_ids)
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id                   = var.subnet_ids[count.index]
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.web.name

  root_block_device {
    encrypted = true # AVD-AWS-0131 (HIGH): Root block device is not encrypted.
  }

  metadata_options {
    http_tokens   = "required" # AVD-AWS-0028 (HIGH): Instance does not require IMDS access to require a token.
    http_endpoint = "enabled"
  }

  user_data = local.ec2_user_data_script

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.instance_name}-${count.index + 1}"
    }
  )

  # Force replacement when user_data changes
  lifecycle {
    replace_triggered_by = [null_resource.ec2_user_data_tracker.id]
  }
}

# Create an IAM role for the web servers
resource "aws_iam_role" "web" {
  name = "${var.environment}-web-role"

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
resource "aws_iam_role_policy_attachment" "web_ssm" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an instance profile for the web servers
resource "aws_iam_instance_profile" "web" {
  name = "${var.environment}-web-profile"
  role = aws_iam_role.web.name
}
