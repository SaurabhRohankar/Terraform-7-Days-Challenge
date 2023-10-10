provider "aws" {
  region = "ap-south-1"
}

# Retrieving default VPC ID
data "aws_vpc" "default" {
  default = true
}

# Launching EC2 instance
resource "aws_instance" "tf-ec2" {
  ami           = "ami-0c42696027a8ede58"
  instance_type = "t2.micro"
  subnet_id     = "subnet-1e6e6776"
  key_name      = "new-key"
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

# Security group for EC2 instance
resource "aws_security_group" "allow-http-ssh-sg" {
  name        = "TF-allow-http-ssh-sg"
  description = "SG made by TF"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

  tags = {
    Name = "TF-allow-http-ssh-sg"
  }
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

