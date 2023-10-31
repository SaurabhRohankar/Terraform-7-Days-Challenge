terraform {
  required_providers {
    aws = {} 
  }

  backend "s3" {
    bucket = "terrafrom-state-lock-bucket-saura-123"
    key = "terrafrom/tarraform.state"
    region = "ap-south-1"
    dynamodb_table = "terrafrom-state-lock-table"
    encrypt = true
  }

}


resource "aws_instance" "Test_tf_ec2_instance" {
  ami           = "ami-0c42696027a8ede58"
  instance_type = "t2.micro"
  subnet_id     = "subnet-1e6e6776"
  key_name      = "new-key"
}
