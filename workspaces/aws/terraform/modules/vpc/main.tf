locals {
  common_tags = merge(
    var.tags,
    {
      Name = "${var.environment}-vpc"
    }
  )
}

# Ignore for now.
# trivy:ignore:AVD-AWS-0178 (MEDIUM): VPC does not have VPC Flow Logs enabled.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
}

# Public Subnet in AZ a
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_a
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}a"

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-public-subnet-a"
    }
  )
}

# Public Subnet in AZ b
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_b
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}b"

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-public-subnet-b"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-igw"
    }
  )
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-public-route-table"
    }
  )
}

# Route Table Association for public subnet a
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# Route Table Association for public subnet b
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# Private Subnet in AZ a
resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_a
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}a"

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-private-subnet-a"
    }
  )
}

# Private Subnet in AZ b
resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_b
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}b"

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-private-subnet-b"
    }
  )
}

# NAT Gateway in AZ a
resource "aws_nat_gateway" "main_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-nat-a"
    }
  )
}

# NAT Gateway in AZ b
resource "aws_nat_gateway" "main_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-nat-b"
    }
  )
}

# EIP for NAT Gateway in AZ a
resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-nat-eip-a"
    }
  )
}

# EIP for NAT Gateway in AZ b
resource "aws_eip" "nat_b" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-nat-eip-b"
    }
  )
}

# Private Route Table for AZ a
resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_a.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-private-route-table-a"
    }
  )
}

# Private Route Table for AZ b
resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_b.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-private-route-table-b"
    }
  )
}

# Private Route Table Association for AZ a
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

# Private Route Table Association for AZ b
resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

# ALB Security Group
resource "aws_security_group" "alb" {
  name        = "${var.environment}-allow-http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP to private subnets"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr_a, var.private_subnet_cidr_b]
  }

  # Ensure the security group is created before destroying to avoid stuck destroy
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-allow-http"
    }
  )
}

# EC2 Security Group
resource "aws_security_group" "ec2" {
  name        = "${var.environment}-allow-alb"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Ignore for now.
  # trivy:ignore:AVD-AWS-0104 (CRITICAL): Security group rule allows egress to multiple public internet addresses.
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ensure the security group is created before destroying to avoid stuck destroy
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-allow-alb"
    }
  )
}

# Bastion Security Group
resource "aws_security_group" "bastion_from_cidr" {
  name        = "${var.environment}-allow-ssh-bastion-from-cidr"
  description = "Allow SSH access to bastion host from specific IP range"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere via EC2 Instance Connect"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_bastion_cidr]
  }

  # Allow SSH to private subnets
  # AVD-AWS-0104 (CRITICAL): Security group rule allows egress to multiple public internet addresses.
  egress {
    description = "SSH to web servers in private subnets"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr_a, var.private_subnet_cidr_b]
  }

  # Allow HTTPS for EC2 Instance Connect
  egress {
    description = "HTTPS for EC2 Instance Connect"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Need to add this to the VPC CIDR block.
    # trivy:ignore:AVD-AWS-0104 (CRITICAL): Security group rule allows egress to multiple public internet addresses.
    cidr_blocks = ["3.5.144.0/23"] # EC2 Instance Connect endpoint for ap-southeast-2 from https://ip-ranges.amazonaws.com/ip-ranges.json
  }

  # Allow internet access for user data script
  # Not safe, but allow for now. It needs to download AWS CLI and fetch the SSH key from Secrets Manager.
  # trivy:ignore:AVD-AWS-0104 (CRITICAL): Security group rule allows egress to multiple public internet addresses.
  egress {
    description = "Allow internet access for user data script"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ensure the security group is created before destroying to avoid stuck destroy
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-allow-ssh-bastion-from-cidr"
    }
  )
}

# Web SSH Security Group
resource "aws_security_group" "web_ssh_from_bastion" {
  name        = "${var.environment}-allow-ssh-web-from-bastion"
  description = "Allow SSH access to web servers from bastion host"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_from_cidr.id]
  }

  # Ignore for now.
  # trivy:ignore:AVD-AWS-0104 (CRITICAL): Security group rule allows egress to multiple public internet addresses.
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ensure the security group is created before destroying to avoid stuck destroy
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-allow-ssh-web-from-bastion"
    }
  )
}
