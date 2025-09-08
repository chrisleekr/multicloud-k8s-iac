resource "aws_lb" "web" {
  name = "${var.environment}-web-alb"
  # Ignore for now.
  # trivy:ignore:AVD-AWS-0053 (HIGH): Load balancer is exposed publicly.
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids
  # AVD-AWS-0052 (HIGH): Application load balancer is not set to drop invalid headers.
  drop_invalid_header_fields = true

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-web-alb"
    }
  )
}

# Add random suffix for uniqueness
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Target group must have an unique name
resource "aws_lb_target_group" "web" {
  name     = "${var.environment}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-web-tg"
    }
  )
}

# Ignore for now.
# trivy:ignore:AVD-AWS-0054 (CRITICAL): Listener for application load balancer does not use HTTPS.
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group_attachment" "web" {
  count            = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = var.instance_ids[count.index]
  port             = 80
}
