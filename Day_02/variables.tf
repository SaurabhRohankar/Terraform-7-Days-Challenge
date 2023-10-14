variable "aws_region" {
    description = "AWS Region"
    type = string
}

variable "ami_id_value" {
    description = "AMI ID of ec2 instance"
    type = string
}

variable "instance_type_value" {
    description = "Instance type of ec2"
    type = string
}

variable "subnet_id_value" {
    description = "Subnet to launch EC2 in"
    type = string
}

variable "key_pair_name_value" {
    description = "Key pair for ssh into EC2"
    type = string
}
