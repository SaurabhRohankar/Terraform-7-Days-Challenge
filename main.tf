provider "aws" {
  region = var.aws_region
}

# Retrieving default VPC ID
data "aws_vpc" "default" {
  default = true
}


data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]  # Replace with your VPC ID
  }

  filter {
    name   = "availability-zone"
    values = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]  # List the desired availability zones
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-http-ssh-sg.id]
  subnets = data.aws_subnets.public_subnets.ids
  #subnets            = [for subnet in data.aws_subnets.public_subnets : subnet]

  enable_deletion_protection = true

  tags = {
    Environment = "Devlopment"
    Terraform = true
  }
}


#creating a target group for alb
resource "aws_lb_target_group" "my-alb-tg" {
  name     = "tf-sample-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

#attaching ec2 instance to target group
resource "aws_lb_target_group_attachment" "my-alb-tg-attachment" {
 count = 3
 target_group_arn = aws_lb_target_group.my-alb-tg.arn
 target_id = aws_instance.tf-ec2[count.index].id
 port = 80
}

#adding lb listener for http
resource "aws_lb_listener" "My-web-listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-alb-tg.arn
  }
}


# Launching EC2 instance
resource "aws_instance" "tf-ec2" {
  count = (var.high_availability == true ? 3 : 1)
  ami           = var.ami_id_value
  instance_type = var.instance_type_value
  subnet_id     = var.subnet_id_value
  key_name      = var.key_pair_name_value
  vpc_security_group_ids = [aws_security_group.allow-http-ssh-sg.id]
  
  # Using file function to read user data script
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "Hello from $(hostname -f)" > /var/www/html/index.html
  EOF

  tags = {
    Name = "TF-EC2"
    Env  = "Dev"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "my-ec2-sg"
  description = "Security group for EC2 instances"

  vpc_id = data.aws_vpc.default.id 

  // Define ingress rule to allow traffic from ALB security group
  ingress {
    from_port   = 80  # Allow traffic on port 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.allow-http-alb-sg.id]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your trusted IP address
  }
}


# Security group for ALB
resource "aws_security_group" "allow-http-alb-sg" {
  name        = "TF-allow-http-alb-sg"
  description = "SG made by TF"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules - allow all outbound traffic by default
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TF-allow-http-alb-sg"
  }
}


