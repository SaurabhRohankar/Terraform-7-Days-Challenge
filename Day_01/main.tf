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

    tags = {
        Name = "TF-allow-http-sg"
    }
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}
