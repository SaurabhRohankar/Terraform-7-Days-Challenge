# Retrieving default VPC ID
data "aws_vpc" "default" {
  default = true
}

#retrieving the publiic subnets
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id] # Replace with your VPC ID
  }

  filter {
    name   = "availability-zone"
    values = ["ap-south-1a", "ap-south-1b", "ap-south-1c"] # List the desired availability zones
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}


resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-http-alb-sg.id]
  subnets            = data.aws_subnets.public_subnets.ids
  #subnets            = [for subnet in data.aws_subnets.public_subnets : subnet]

  enable_deletion_protection = true

  tags = {
    Environment = "Devlopment"
    Terraform   = true
  }
}


#creating a target group for alb
resource "aws_lb_target_group" "my-alb-tg" {
  name     = "tf-sample-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


#adding lb listener for http
resource "aws_lb_listener" "My-web-listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = local.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-alb-tg.arn
  }
}



resource "aws_launch_template" "sample-webserver-lt" {
  name                   = "my-webserver-lt"
  image_id               = var.ami_id_value
  instance_type          = var.instance_type_value
  key_name               = var.key_pair_name_value
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "TF-EC2"
      Env  = "Dev"
    }
  }

  # Render the User Data script as a template
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    greeter_name = var.greeter_name
  }))
}


resource "aws_autoscaling_group" "mywebserver-asg" {
  desired_capacity    = var.desired_size
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = data.aws_subnets.public_subnets.ids
  target_group_arns   = [aws_lb_target_group.my-alb-tg.arn]

  launch_template {
    id      = aws_launch_template.sample-webserver-lt.id
    version = "$Latest"
  }
}


resource "aws_security_group" "ec2_sg" {
  name        = "my-ec2-sg"
  description = "Security group for EC2 instances"

  vpc_id = data.aws_vpc.default.id

  // Define ingress rule to allow traffic from ALB security group
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = [aws_security_group.allow-http-alb-sg.id]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your trusted IP address
  }

  # Outbound rules - allow all outbound traffic by default
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Security group for ALB
resource "aws_security_group" "allow-http-alb-sg" {
  name        = "TF-allow-http-alb-sg"
  description = "SG made by TF"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  # Outbound rules - allow all outbound traffic by default
  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }

  tags = {
    Name = "TF-allow-http-alb-sg"
  }
}


