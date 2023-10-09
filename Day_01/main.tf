provider "aws" {
    region = "ap-south-1"
}

#retrieving default vpc id
data "aws_vpc" "default" {
  default = true
}


#launching ec2 instance
resource "aws_instance" "tf-ec2" {
    ami = "ami-0c42696027a8ede58"
    instance_type = "t2.micro"
    subnet_id = "subnet-1e6e6776"
    security_groups = [aws_security_group.allow-http-sg.id]
    key_name = "new-key"
   
#using file function to read user data script

    user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl start htttp -y
    sudo systemctl enable httpd
    echo "Hi from $(hostname -f)" > /var/www/html/index.html
    EOF

    tags =  {
        Name = "TF-EC2"
        Env = "Dev"
    }
}

#SG for ec2 instance
resource "aws_security_group" "allow-http-sg" {
    name = "TF-allow-http-sg"
    description = "SG made by TF"
    vpc_id = data.aws_vpc.default.id

    ingress {
        description = "http from anywhere"
        from_port = 80
        to_port = 80
        cidr_blocks =  ["0.0.0.0/0"]
        protocol = "tcp"
    }

    ingress {
        description = "For SSH"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }

    tags = {
        Name = "TF-allow-http-sg"
    }
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "public_ip" {
  value = aws_instance.tf-ec2.public_ip
}
